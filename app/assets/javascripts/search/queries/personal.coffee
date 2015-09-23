class Clarat.Search.Query.Personal extends Clarat.Search.Query.Base
  SEARCH_RADIUS: 50000

  # TODO: geolocation
  constructor: (@geolocation, @exact_location = false, args...) ->
    super args...
    console.log @exact_location
    @SEARCH_RADIUS = 500 if @exact_location == 'true'
    console.log @SEARCH_RADIUS

  query_hash: ->
    _.merge super(),
      indexName: Clarat.Algolia.personalIndexName,
      params:
        aroundLatLng: @geolocation
        aroundRadius: @SEARCH_RADIUS
