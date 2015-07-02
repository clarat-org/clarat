initMapModal = ->
  map_container = $(".template--offers-index #map-container")

  if map_container.length
    $('#big-map').popup
      opacity: 0.3
      transition: 'all 0.3s'
      onopen: enlargeMap
      onclose: revertMap

enlargeMap = ->
  map = Clarat.currentMap.instance # local var
  map_modal = $("#big-map")
  map_canvas = $("#map-canvas")

  map_canvas.css "height", "100%"
  map_canvas.appendTo map_modal # move into inner modal container
  google.maps.event.trigger map, 'resize'

  Clarat.GMaps.Map.setMapBounds()

revertMap = ->
  map_canvas = $("#map-canvas")
  map_container = $(".template--offers-index #map-container")

  map_canvas.css "height", 300 # or inital
  map_canvas.appendTo map_container # move back to original place

  google.maps.event.trigger Clarat.currentMap.instance, 'resize'
  # Set original bounds
  Clarat.GMaps.Map.setMapBounds()


$(document).on 'page:load', initMapModal
$(document).ready initMapModal
