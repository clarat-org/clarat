class PersonalQuery < BaseQuery
  attr_reader :geolocation, :search_radius

  # TODO: geolocation
  def initialize(geolocation:, search_radius: 50_000, **args)
    super(args)
    @geolocation = geolocation
    @search_radius = search_radius
  end

  def query_hash
    super.merge(
      index_name: Offer.personal_index_name,
      aroundLatLng: geolocation,
      aroundRadius: search_radius
    )
  end
end
