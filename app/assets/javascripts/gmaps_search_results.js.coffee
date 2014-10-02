initialize = ->
  canvas = document.getElementById('map-canvas')
  markers = $(canvas).data('markers')
  if markers.length
    userPosition = $(canvas).data('position')
    userPosition = new google.maps.LatLng(
      userPosition.latitude,
      userPosition.longitude
    )
    mapOptions =
      zoom: 11
      center: userPosition

    map = new google.maps.Map(canvas, mapOptions)
    bounds = new google.maps.LatLngBounds()
    bounds.extend userPosition

    for marker in markers
      markerPosition = new google.maps.LatLng(
        marker.latitude,
        marker.longitude
      )
      new google.maps.Marker
        position: markerPosition
        map: map

      bounds.extend markerPosition

    map.fitBounds bounds

google.maps.event.addDomListener window, 'load', initialize
google.maps.event.addDomListener document, 'page:load', initialize
