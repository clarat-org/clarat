class Clarat.Search.Operation.BuildMap
  @run: (mainResultSet) ->
    markers = new Clarat.Search.Cell.MapMarkers mainResultSet
    if Clarat.GMaps.loaded && !Clarat.GMaps.presenter # This is necessary as the presenter gets called on every single pagination call while the previous one is not being killed. TO DO: Refactor!
      Clarat.GMaps.presenter = new Clarat.GMaps.Presenter(markers)
    else
      $('#search-wrapper').append(
        $(
          "<div id='map-data' data-markers='#{JSON.stringify markers}'
          data-ui='{\"autoenlarge\": false}'>"
        )
      )
