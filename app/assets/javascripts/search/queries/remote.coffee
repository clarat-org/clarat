class Clarat.Search.Query.Remote extends Clarat.Search.Query.Base

  constructor: (@geolocation, @teaser = false, args...) ->
    super args...

  query_hash: ->
    mergedHash = _.chain super()
      .merge(
        indexName: Clarat.Algolia.remoteIndexName
        params:
          numericFilters: @area_filter()
      )
      .merge @page_options()
      .value()
    mergedHash

  page_options: ->
    if @teaser
      {
        params:
          page: 0
          hitsPerPage: 1
      }
    else
      {}

  # Remote search is in a separate index and uses the area as a bounding box,
  # in a general search context this only gets 2 results as a teaser
  area_filter: ->
    [lat, lng] = @geolocation.split ','
    "area_minlat<=#{lat},area_maxlat>=#{lat},\
    area_minlong<=#{lng},area_maxlong>=#{lng}"
