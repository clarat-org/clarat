class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  # def persisted?
  #   false
  # end

  attribute :query, String
  attribute :search_location, String
  attribute :geoloc, String

  def search page
    Offer.search query,
      hitsPerPage: 5,
      aroundLatLng: geoloc,
      aroundRadius: 999999999
  end
end