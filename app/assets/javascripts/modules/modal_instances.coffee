initMapModal = ->
  map_container = $(".template--offers-index #map-container")

  if map_container.length
    $('#big-map').popup
      opacity: 0.3
      transition: 'all 0.3s'
      onopen: enlargeMap
      onclose: revertMap

enlargeMap = ->
  map = Clarat.currentMap # local var
  map_modal = $("#big-map")
  map_canvas = $("#map-canvas")

  unless map.initialCenter == "undefined"
    Clarat.currentMap.initialCenter = map.getCenter() # Set in global namespace

  map_canvas.css "height", "100%"
  map.setZoom 13
  map_canvas.appendTo map_modal # move into inner modal container
  google.maps.event.trigger map, 'resize'
  return

revertMap = ->
  map = Clarat.currentMap # local var
  map_canvas = $("#map-canvas")
  map_container = $(".template--offers-index #map-container")

  map.setCenter map.initialCenter # Get from global namespace
  map_canvas.css "height", 300 # or inital
  map.setZoom 15 # or inital
  map_canvas.appendTo map_container # move back to original place
  google.maps.event.trigger map, 'resize'
  return


$(document).on 'page:load', initMapModal
$(document).ready initMapModal
