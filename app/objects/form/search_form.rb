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
  attribute :tags, String

  def search page
    @hits = Offer.algolia_search query,
                                 page: page,
                                 aroundLatLng: geolocation,
                                 aroundRadius: 999_999_999,
                                 tagFilters: tags,
                                 facets: '_tags',
                                 maxValuesPerFacet: 20

  end

  def has_nearby?
    @_has_nearby ||=
      Offer.algolia_search('',
                           page: 0,
                           hitsPerPage: 1,
                           aroundLatLng: geolocation,
                           aroundRadius: 25_000 # check later if this is accurate
      ).any?
  end

  def geolocation
    return @geolocation if @geolocation

    result = if search_location == I18n.t('conf.current_location')
      if generated_geolocation.empty? # could cause problems
        raise InvalidLocationError
      else
        generated_geolocation
      end
    else
      SearchLocation.find_or_generate search_location
    end
    @geolocation = Geolocation.new result
  end

  def tags_by_facet
    tags_facet = @hits.facets['_tags']
    if tags_facet
      inverted = tags_facet.each_with_object({}) do |(key, value), out|
        (out[value] ||= []) << key
      end # safe invert
      inverted.values.flatten.uniq
    else
      []
    end
  end

  # toggles tag on or off
  def toggle tag
    newtags = tag_array
    newtags << tag unless newtags.delete(tag)
    { query: query, tags: newtags.join(',') }
  end

  # @return [Boolean]
  def includes_tag tag
    self.tag_array.include? tag
  end

  def tag_array
    if tags
      tags.split(',').map(&:strip)
    else
      []
    end
  end

  def location_for_cookie
    { query: search_location, geoloc: geolocation.to_s }.to_json
  end
end
