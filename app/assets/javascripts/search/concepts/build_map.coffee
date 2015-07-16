class Clarat.Search.Concept.BuildMap
  @run: (mainResultSet) ->
    markers = new Clarat.Search.Cell.MapMarkers mainResultSet
    if Clarat.GMaps.loaded
      Clarat.GMaps.Map.initialize(markers)
    else
      $('#search-wrapper').append(
        $("<div id='map-data' data-markers='#{JSON.stringify markers}'>")
      )
