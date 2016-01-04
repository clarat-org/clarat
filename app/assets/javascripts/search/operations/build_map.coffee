class Clarat.Search.Operation.BuildMap
  @run: (mainResultSet) ->
    markers = new Clarat.Search.Cell.MapMarkers mainResultSet
    if Clarat.GMaps.loaded
      Clarat.GMaps.presenter = new Clarat.GMaps.Presenter(markers)
    else
      $('#search-wrapper').append(
        $("<div id='map-data' data-markers='#{JSON.stringify markers}'>")
      )
