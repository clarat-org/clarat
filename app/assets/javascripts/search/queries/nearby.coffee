class Clarat.Search.Query.Nearby
  NEARBY_RADIUS: 25000 # check later if accurate

  # TODO: geolocation
  constructor: (@geolocation, @section) ->

  query_hash: ->
    indexName: Clarat.Algolia.personalIndexName,
    query: ''
    params:
      page: 0
      hitsPerPage: 1
      aroundLatLngViaIP: true
      aroundRadius: @NEARBY_RADIUS
      facetFilters: ["_section_filters:#{@section}"]
