class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion
  extend Enumerize

  attr_accessor :hits, :personal_hits, :remote_hits, :national_hits,
                :location_fallback

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String
  attribute :category, String

  # Hidden Option
  attribute :exact_location, Boolean, default: false

  # Filters
  CONTACT_TYPES = [:personal, :remote]
  attribute :contact_type, String, default: :personal
  enumerize :contact_type, in: CONTACT_TYPES
  # Age
  attribute :age_filter, String
  enumerize :age_filter, in: AgeFilter::IDENTIFIER
  # Audience
  attribute :audience_filter, String
  enumerize :audience_filter, in: AudienceFilter::IDENTIFIER
  # Language
  attribute :language_filter, String
  enumerize :language_filter, in: LanguageFilter::IDENTIFIER

  def search page
    return @hits if @hits

    # kaminari starts pagination at 1, Algolia starts at 0
    page -= 1 if page && page > 0 # TODO: increase later

    @search_stack = []

    send("prepare_#{contact_type}_specific_search".to_sym, page)
    prepare_general_search
    execute_search
  end

  def prepare_personal_specific_search page
    @search_stack.push [:personal_hits, personal_search_options(page)]
    @search_stack.push [:remote_hits, remote_search_options(page, true)]
  end

  def prepare_remote_specific_search page
    @search_stack.push [:remote_hits, remote_search_options(page)]
  end

  def prepare_general_search
    @search_stack.push [:_nearby, nearby_search_options]
    @search_stack.push [:facet_hits, facet_search_options]
  end

  # Multi Query from the ruby client
  def execute_search
    variables = @search_stack.map { |el| el[0] }
    searches = @search_stack.map { |el| el[1] }
    @hits = Algolia.multiple_queries(searches)['results']
    variables.each_with_index do |variable, index|
      instance_variable_set "@#{variable}", SearchResults.new(@hits[index])
    end
  end

  def nearby?
    @_nearby.any?
  end

  def geolocation
    @geolocation ||= Geolocation.new geolocation_result
  end

  def geolocation_result
    if exact_location
      generated_geolocation
    elsif search_location == I18n.t('conf.current_location')
      raise InvalidLocationError if generated_geolocation.empty?
      generated_geolocation
    elsif search_location.blank?
      @location_fallback = true
      SearchLocation.find_by_query I18n.t('conf.default_location')
    else
      SearchLocation.find_or_generate search_location
    end
  end

  def facet_counts_for_query
    @facet_hits.facets['_tags'] || {}
  end

  # find the actual category object and return it with ancestors
  def category_with_ancestors
    unless category.blank?
      @category_with_ancestors ||=
        Category.find_by_name(category).self_and_ancestors.reverse
    end
  end

  # link hash with empty query
  def empty
    to_h.merge query: ''
  end

  # link hash that focuses on a specific category
  def category_focus category
    name = category.is_a?(String) ? category : category.name
    to_h.merge category: name
  end

  def category_in_focus? name
    if category_with_ancestors
      @category_with_ancestor_names ||= category_with_ancestors.map(&:name)
      @category_with_ancestor_names.include? name
    end
  end

  # link hash that toggles the contact type to remote only
  def remote_focus
    to_h.merge contact_type: :remote
  end

  def remote_focussed?
    contact_type == :remote
  end

  def location_for_cookie
    return nil if search_location.blank?
    { query: search_location, geoloc: geolocation.to_s }.to_json
  end

  private

  def search_query
    query || ''
  end

  # wide radius or use exact location
  def search_radius
    exact_location ? 100 : 50_000
  end

  def search_filters
    unless @filters
      @filters = []
      %w(age audience language).each do |type|
        requested_filter = send("#{type}_filter")
        @filters.push "_#{type}_filters:#{requested_filter}" if requested_filter
      end
    end
    @filters
  end

  def search_options page
    opts = {
      query: search_query,
      tagFilters: category,
      facets: '_age_filters,_audience_filters,_language_filters',
      facetFilters: search_filters,
      aroundPrecision: 500
    }
    page ? opts.merge(page: page, hitsPerPage: SearchResults::PER_PAGE) : opts
  end

  # personal search is the basic search, ranked by distance
  def personal_search_options page = nil
    search_options(page).merge(
      index_name: Offer.personal_index_name,
      aroundLatLng: geolocation,
      aroundRadius: search_radius
    )
  end

  # Remote search is in a separate index and uses the area as a bounding box,
  # in a general search context this only gets 2 results as a teaser
  def remote_search_options page, teaser = false
    lat, long = [geolocation.latitude, geolocation.longitude]
    opts = search_options(page).merge(
      index_name: Offer.remote_index_name,
      numericFilters:
        "area_minlat<=#{lat},area_maxlat>=#{lat},area_minlong<=#{long}," +
        "area_maxlong>=#{long}"
    )
    opts.merge(page: 0, hitsPerPage: 2) if teaser
    opts
  end

  def nearby_search_options
    {
      index_name: Offer.personal_index_name,
      query: '',
      page: 0,
      hitsPerPage: 1,
      aroundLatLng: geolocation,
      aroundRadius: 25_000 # check later if accurate
    }
  end

  # TODO: mergable with nearby?
  def facet_search_options
    # maxValuesPerFacet: 20,
    personal_search_options.merge(
      facets: '_tags', page: 0, hitsPerPage: 1, tagFilters: ''
    )
  end
end
