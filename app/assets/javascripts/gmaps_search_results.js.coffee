initialize = ->
  canvas = document.getElementById('map-canvas')
  markers = $(canvas).data('markers')
  if markers.length

    # Get User Position
    userPosition = $(canvas).data('position')
    userPosition = new google.maps.LatLng(
      userPosition.latitude,
      userPosition.longitude
    )
    mapOptions =
      zoom: 11
      center: userPosition

    # Create Map and Center to User Position
    map = new google.maps.Map(canvas, mapOptions)
    bounds = new google.maps.LatLngBounds()
    bounds.extend userPosition

    # Create Markers
    for marker in markers
      markerPosition = new google.maps.LatLng(
        marker.latitude,
        marker.longitude
      )
      markerInstance = new google.maps.Marker
        position: markerPosition
        map: map

      bounds.extend markerPosition

      # Bind Event Listeners To Marker
      google.maps.event.addListener markerInstance, 'mouseover', (event) ->
        console.log "ids for this hover:"
        console.log marker

    # Expand Map to Include Markers
    map.fitBounds bounds


google.maps.event.addDomListener window, 'load', initialize
google.maps.event.addDomListener document, 'page:load', initialize
