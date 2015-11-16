class Clarat.GMaps.Operation.ConstructMap
  @run: (markers, canvas) ->
    includedPoints = []
    marker_url =
      if @_isInternetExplorer11()
        'gmaps_marker_1.png'
      else
        'gmaps_marker_1.svg'

    # Create Map
    mapOptions =
      scrollwheel: false
      mapTypeControl: false,
      zoomControl: false,
      streetViewControl: false

    map = new google.maps.Map(canvas, mapOptions)
    bounds = new google.maps.LatLngBounds()

    # Create Markers inside Map
    for key, markerData of markers
      continue unless markerData.position
      markerPosition = new google.maps.LatLng(
        markerData.position.latitude,
        markerData.position.longitude
      )
      marker = new google.maps.Marker
        position: markerPosition
        map: map
        icon: image_path(marker_url)

      includedPoints.push markerPosition
      bounds.extend markerPosition

      # Bind Event Listeners To Marker
      @_bindMapsEvents map, marker, markerData, canvas
      # @_bindMarkerToResults marker, markerData, infowindow

    # Get User Position
    userPosition = $(canvas).data('position')
    if userPosition
      # Include User Position in Map
      userPosition = new google.maps.LatLng(
        userPosition.latitude,
        userPosition.longitude
      )
      # if not exact location as only other marker
      unless includedPoints.length is 1 and
             userPosition.toString() == includedPoints[0].toString()
        includedPoints.push userPosition
        bounds.extend userPosition

    # Return created map handling objects
    return {
      instance: map
      bounds: bounds
      includedPoints: includedPoints
    }


  ### PRIVATE ###


  @_isInternetExplorer11: ->
    navigator.userAgent.toLowerCase().indexOf('trident') > -1

  # Event bindings for a single marker inside a map
  @_bindMapsEvents: (map, marker, markerData, canvas) ->
    google.maps.event.addListener(
      marker, 'click', ->
        $('#map-container').trigger(
          'Clarat.GMaps::MarkerClick', [marker, markerData]
        )
    )
    google.maps.event.addListener(
      map, 'click', ->
        $('#map-container').trigger 'Clarat.GMaps::MapClick'
    )

  # @_bindMarkerToResults: (marker, markerData) ->
  #   for offerID in markerData.ids
  #     $("#result-offer-#{offerID}").data('marker', marker)
