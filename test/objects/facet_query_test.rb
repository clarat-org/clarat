require_relative '../test_helper'

describe FacetQuery do
  it 'returns an executable hash' do
    geolocation = Geolocation.new OpenStruct.new(latitude: 1, longitude: 1)
    query = FacetQuery.new(
      query: 'blub',
      category: '-1',
      geolocation: geolocation
    )
    query.query_hash.keys.must_include :facets
    query.query_hash.to_a.must_include([:tagFilters, ''])
  end
end
