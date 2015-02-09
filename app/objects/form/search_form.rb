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

  def search page
    @hits = Offer.algolia_search query,
                                 page: page,
                                 aroundLatLng: geolocation,
                                 aroundRadius: 999_999_999,
                                 tagFilters: categories,
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
    categories_facet = @hits.facets['_tags']
    if categories_facet
      inverted = categories_facet.each_with_object({}) do |(key, value), out|
        (out[value] ||= []) << key
      end # safe invert
      inverted.values.flatten.uniq
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
