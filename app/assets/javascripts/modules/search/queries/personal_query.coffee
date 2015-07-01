class Clarat.Search.PersonalQuery extends Clarat.Search.BaseQuery
  SEARCH_RADIUS: 50000

  # TODO: geolocation
  constructor: (@geolocation, args...) ->
    super args...

  query_hash: ->
    _.merge super(),
      indexName: Clarat.Search.personalIndexName,
      params:
        aroundLatLng: @geolocation
        aroundRadius: @SEARCH_RADIUS
