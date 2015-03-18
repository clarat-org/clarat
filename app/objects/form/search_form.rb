class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  attr_accessor :hits, :local_hits, :national_hits, :location_fallback
  # def persisted?
  #   false
  # end

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String
  attribute :category, String
  attribute :exact_location

  def search page
    # kaminari starts pagination at 1, Algolia starts at 0
    page -= 1 if page && page > 0

    # Multi Query from the ruby client
    @hits ||= Algolia.multiple_queries([
      local_search_options(page),
      national_search_options(page),
      nearby_search_options,
      local_search_options.merge(facets: '*')
    ])
    @local_hits    = SearchResults.new @hits['results'][0]
    @national_hits = SearchResults.new @hits['results'][1]
    @_nearby       = SearchResults.new @hits['results'][2]
    @facet_hits    = SearchResults.new @hits['results'][3]
  end

  # algoliasearch-rails doesn't suport multi queries. Turn variables into the
  # Pagination object that would normally be returned.
  # def algoliasearch_railsify
  #   [@local_hits, @national_hits, @_nearby, @facet_hits].each do |hit|
  #     hit_ids
  #   end
  #   AlgoliaSearch::Pagination::Kaminari.create
  #   # PULL REQUEST TO ALGOLIASEARCH RAILS?
  #   #https://github.com/algolia/algoliasearch-rails/blob/907197ccf99e3b0a9d19ce8b08dc55e32066a418/lib/algoliasearch-rails.rb
  # end

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

  # wide radius or use exact location
  def search_radius
    exact_location ? 100 : 50_000
  end

  def facet_counts_for_query
    @facet_hits.facets['_tags']
  end

  # find the actual category object and return it with ancestors
  def category_with_ancestors
    unless category.blank?
      @category_with_ancestors ||=
        Category.find_by_name(category).self_and_ancestors.reverse
    end
  end

  def category_in_focus? name
    if category_with_ancestors
      @category_with_ancestor_names ||= category_with_ancestors.map(&:name)
      @category_with_ancestor_names.include? name
    end
  end

  # link hash that focuses on a specific category
  def focus category
    name = category.is_a?(String) ? category : category.name
    { query: query, category: name, search_location: search_location }
  end

  # link hash with empty query
  def empty
    { query: '', category: category, search_location: search_location }
  end

  def hit_count
    @local_hits.nbHits
  end

  def location_for_cookie
    return nil if search_location.blank?
    { query: search_location, geoloc: geolocation.to_s }.to_json
  end

  private

  def search_query
    query || ''
  end

  def search_options page
    opts = {
      query: search_query,
      tagFilters: category,
      maxValuesPerFacet: 20,
      aroundPrecision: 500
    }
    page ? opts.merge(page: page, hitsPerPage: SearchResults::PER_PAGE) : opts
  end

  def local_search_options page = nil
    search_options(page).merge(
      index_name: Offer.local_index_name,
      aroundLatLng: geolocation,
      aroundRadius: search_radius
    )
  end

  def national_search_options page
    search_options(page).merge(index_name: Offer.national_index_name)
  end

  def nearby_search_options
    {
      index_name: Offer.local_index_name,
      query: '',
      page: 0,
      hitsPerPage: 1,
      aroundLatLng: geolocation,
      aroundRadius: 25_000 # check later if accurate
    }
  end
end
