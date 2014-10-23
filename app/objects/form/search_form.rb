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
    @hits = Offer.search query,
                         page: page,
                         aroundLatLng: geolocation,
                         aroundRadius: 999_999_999,
                         tagFilters: tags,
                         facets: '_tags'
  end

  def geolocation
    @geolocation ||=
      if generated_geolocation == 'Dein Standort'
        generated_geolocation
      else
        result = SearchLocation.find_or_generate search_location
        Geolocation.new result
      end
  end

  def tags_by_facet
    tags_facet = @hits.facets['_tags']
    inverted = tags_facet.each_with_object( {} ) do |(key, value), out|
      ( out[value] ||= [] ) << key
    end # safe invert
    inverted.values.flatten.uniq
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

  # TODO: put in helper, i18n
  def humanized_explanation
    str = ''
    if query
      str += "für den Suchbegriff \"#{query}\""
    end
    ta = tag_array
    if ta.any?
      if ta.length == 1
        str += " mit dem Schlagwort #{ta[0]}"
      else
        str += ' mit den Schlagworten '
        str += ta.to_sentence(locale: :de) # I18n.locale
      end
    end
    str
  end
end
