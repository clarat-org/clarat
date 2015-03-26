class SearchForm
  # Turn into Quasi ActiveModel
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  # Extensions
  extend Enumerize

  # Modules (located in the search_form subfolder)
  include SearchExecution

  # Attributes (since this is not ActiveRecord)

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

  # Methods

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
end
