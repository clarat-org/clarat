class Clarat.Search.RemoteQuery extends Clarat.Search.BaseQuery

  # TODO: geolocation
  constructor: (@geolocation, @teaser = false, args...) ->
    super args...

  query_hash: ->
    _.merge(
      _.merge(
        super(),
        {
          indexName: Clarat.Search.remoteIndexName
          params:
            numericFilters: @area_filter()
        }
      ),
      @page_options()
    )

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
