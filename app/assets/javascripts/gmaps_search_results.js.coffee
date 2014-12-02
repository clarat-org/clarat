initialize = ->
  canvas = document.getElementById('map-canvas')
  markers = $(canvas).data('markers')

  if markers
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
    for key, markerData of markers
      markerPosition = new google.maps.LatLng(
        markerData.position.latitude,
        markerData.position.longitude
      )
      marker = new google.maps.Marker
        position: markerPosition
        map: map
        icon: '/assets/gmaps_marker_1.svg'

      bounds.extend markerPosition

      # Bind Event Listeners To Marker
      bindMapsEvents marker, markerData
      bindMarkerToResults marker, markerData

    # Expand Map to Include Markers
    map.fitBounds bounds

    bindExternalEvents()

bindMapsEvents = (marker, markerData) ->
  google.maps.event.addListener marker, 'mouseover', (event) ->
    for offerID in markerData.offer_ids
      $("#result-offer-#{offerID}").addClass 'JS-highlighted'

  google.maps.event.addListener marker, 'mouseout', (event) ->
    for offerID in markerData.offer_ids
      $("#result-offer-#{offerID}").removeClass 'JS-highlighted'

  google.maps.event.addListener marker, 'click', (event) ->
    offerID = markerData.offer_ids[0] # specification needed
    $('html, body').animate
      scrollTop: $("#result-offer-#{offerID}").offset().top - 120
    , 'fast'

bindMarkerToResults = (marker, markerData) ->
  for offerID in markerData.offer_ids
    $("#result-offer-#{offerID}").data('marker', marker)

bindExternalEvents = ->
  $('.JS-trigger-marker').on 'mouseover', (event) ->
    marker = $(event.delegateTarget).data('marker')
    if marker and marker.getAnimation() == null
      marker.setAnimation google.maps.Animation.BOUNCE

  $('.JS-trigger-marker').on 'mouseout', (event) ->
    marker = $(event.delegateTarget).data('marker')
    if marker and marker.getAnimation() != null
      marker.setAnimation null

google.maps.event.addDomListener window, 'load', initialize
google.maps.event.addDomListener document, 'page:load', initialize
