class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  attr_accessor :hits
  # def persisted?
  #   false
  # end

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String
  attribute :categories, String

  # Query the index
  def search page
    @local_hits = Offer.algolia_search query,
                                       page: page,
                                       aroundLatLng: geolocation,
                                       aroundRadius: 50_000,
                                       tagFilters: categories,
                                       facets: '*',
                                       maxValuesPerFacet: 20,
                                       aroundPrecision: 500
    @global_hits = Offer.algolia_search query,
                                        page: page,
                                        tagFilters: categories,
                                        facets: '*',
                                        maxValuesPerFacet: 20,
                                        hitsPerPage: 5
  end

  # See if an empty search would return results
  def nearby?
    @_nearby ||=
      Offer.algolia_search('',
                           page: 0,
                           hitsPerPage: 1,
                           aroundLatLng: geolocation,
                           aroundRadius: 50_000 # check later if accurate
      ).any?
  end

  def geolocation
    return @geolocation if @geolocation

    @geolocation = Geolocation.new geolocation_result
  end

  def geolocation_result
    if search_location == I18n.t('conf.current_location')
      if generated_geolocation.empty? # could cause problems
        raise InvalidLocationError
      else
        generated_geolocation
      end
    else
      SearchLocation.find_or_generate search_location
    end
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

  # toggles category on or off
  def toggle category
    newcategories = category_array
    newcategories << category unless newcategories.delete(category)
    {
      query: query, categories: newcategories.join(','), search_location: search_location
    }
  end

  # @return [Boolean]
  def includes_category category
    self.category_array.include? category
  end

  def category_array
    if categories
      categories.split(',').map(&:strip)
    else
      []
    end
  end

  def hit_count
    @hits.raw_answer['nbHits']
  end

  def location_for_cookie
    { query: search_location, geoloc: geolocation.to_s }.to_json
  end
end
