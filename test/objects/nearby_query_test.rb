require_relative '../test_helper'

describe NearbyQuery do
  it 'returns a executable hash' do
    geolocation = Geolocation.new OpenStruct.new(latitude: 1, longitude: 1)
    query = NearbyQuery.new(geolocation: geolocation)
    query.query_hash.keys.wont_include :facets
    query.query_hash.to_a.must_include([:aroundRadius, 25_000])
  end
end
