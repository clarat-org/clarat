class Clarat.Search.Query.Personal extends Clarat.Search.Query.Base
  SEARCH_RADIUS: 50000

  # TODO: geolocation
  constructor: (@geolocation, @exact_location, args...) ->
    super args...
    @SEARCH_RADIUS = 100 if @exact_location == 'true'

  query_hash: ->
    _.merge super(),
      indexName: Clarat.Algolia.personalIndexName,
      params:
        aroundLatLng: @geolocation
        aroundRadius: @SEARCH_RADIUS
