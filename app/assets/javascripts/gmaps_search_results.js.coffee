initialize = ->
  canvas = document.getElementById('map-canvas')
  userPosition = $(canvas).data('position')
  userPosition = new google.maps.LatLng(
    userPosition.latitude,
    userPosition.longitude
  )
  mapOptions =
    zoom: 11
    center: userPosition

  map = new google.maps.Map(canvas, mapOptions)

  markers = $(canvas).data('markers')
  for marker in markers
    markerPosition = new google.maps.LatLng(
      marker.latitude,
      marker.longitude
    )
    new google.maps.Marker
      position: markerPosition
      map: map

google.maps.event.addDomListener window, 'load', initialize
