class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  # def persisted?
  #   false
  # end

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String

  def search page
    Offer.search query,
      page: page,
      aroundLatLng: geolocation,
      aroundRadius: 999999999
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
end