class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  attr_accessor :hits, :location_fallback
  # def persisted?
  #   false
  # end

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String
  attribute :category, String
  attribute :exact_location

  def search page
    @hits = Offer.algolia_search query || '',
                                 page: page,
                                 aroundLatLng: geolocation,
                                 aroundRadius: search_radius,
                                 tagFilters: category,
                                 facets: '*',
                                 maxValuesPerFacet: 20,
                                 aroundPrecision: 500
  end

  def nearby?
    @_nearby ||=
      Offer.algolia_search('',
                           page: 0,
                           hitsPerPage: 1,
                           aroundLatLng: geolocation,
                           aroundRadius: 25_000 # check later if accurate
      ).any?
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

  # Super wide radius or use exact location
  def search_radius
    exact_location ? 100 : 50_000
  end

  def categories_by_facet
    categories_facet = @hits.facets['_tags'] # eg { 'foo' => 5, 'bar' => 2 }
    if categories_facet
      categories_facet.to_a.sort_by { |facet| facet[1] }.reverse!
      # categories_facet.each_with_object({}) do |(key, value), out|
      #   (out[value] ||= []) << key
      # end # safe invert; eg { 5 => 'foo' }
      # inverted.values.flatten.uniq
    else
      []
    end
  end

  # find the actual category object and return it with ancestors
  def category_with_ancestors
    Category.find_by_name(category).self_and_ancestors.reverse
  end

  # link hash that focuses on a specific category
  def focus category
    name = category.is_a?(String) ? category : category.name
    { query: query, category: name, search_location: search_location }
  end

  # # toggles category on or off
  # def toggle category
  #   newcategories = category_array
  #   newcategories << category unless newcategories.delete(category)
  #   {
  #     query: query, categories: newcategories.join(','),
  #     search_location: search_location
  #   }
  # end

  # # @return [Boolean]
  # def includes_category category
  #   self.category_array.include? category
  # end

  # def categories_array
  #   if category
  #     categories.split(',').map(&:strip)
  #   else
  #     []
  #   end
  # end

  def hit_count
    @hits.raw_answer['nbHits']
  end

  def location_for_cookie
    return nil if search_location.blank?
    { query: search_location, geoloc: geolocation.to_s }.to_json
  end
end
