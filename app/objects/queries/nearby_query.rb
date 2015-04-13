class NearbyQuery
  attr_reader :geolocation

  # TODO: geolocation
  def initialize(geolocation:)
    @geolocation = geolocation
  end

  def query_hash
    {
      index_name: Offer.personal_index_name,
      query: '',
      page: 0,
      hitsPerPage: 1,
      aroundLatLng: geolocation,
      aroundRadius: 25_000 # check later if accurate
    }
  end
end
