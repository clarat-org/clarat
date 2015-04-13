require_relative '../test_helper'

describe RemoteQuery do
  it 'returns an executable hash' do
    geolocation = Geolocation.new OpenStruct.new(latitude: 1, longitude: 1)
    query = RemoteQuery.new(
      query: 'blub',
      category: '-1',
      geolocation: geolocation
    )
    query.query_hash.keys.must_include :numericFilters
  end
end
