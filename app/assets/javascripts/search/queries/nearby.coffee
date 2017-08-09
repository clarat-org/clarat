class Clarat.Search.Query.Nearby
  NEARBY_RADIUS: 25000 # check later if accurate

  # TODO: geolocation
  constructor: (@geolocation, @section_identifier) ->

  query_hash: ->
    indexName: Clarat.Algolia.personalIndexName,
    query: ''
    params:
      page: 0
      hitsPerPage: 1
      aroundLatLng: @geolocation
      aroundRadius: @NEARBY_RADIUS
      facetFilters: ["section_identifier:#{@section_identifier}"]
