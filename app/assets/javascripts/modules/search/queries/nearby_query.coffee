class Clarat.Search.NearbyQuery
  NEARBY_RADIUS: 25000 # check later if accurate

  # TODO: geolocation
  constructor: (@geolocation) ->

  query_hash: ->
    indexName: Clarat.Search.personalIndexName,
    query: ''
    params:
      page: 0
      hitsPerPage: 1
      aroundLatLng: @geolocation
      aroundRadius: @NEARBY_RADIUS
