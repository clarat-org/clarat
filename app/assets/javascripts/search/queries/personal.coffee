class Clarat.Search.Query.Personal extends Clarat.Search.Query.Base
  SEARCH_RADIUS: 50000

  # TODO: geolocation
  constructor: (@geolocation, args...) ->
    super args...

  query_hash: ->
    _.merge super(),
      indexName: Clarat.Algolia.personalIndexName,
      params:
        aroundLatLng: @geolocation
        aroundRadius: @SEARCH_RADIUS
