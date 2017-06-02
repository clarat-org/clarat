class Clarat.GMaps.Operation.ConstructMap
  @markerUrl: (image_name) ->
    if @_isInternetExplorer11()
      image_path("#{image_name}.png")
    else
      image_path("#{image_name}.svg")

  @run: (markers, canvas, mapOptions, uiOptions) ->
    includedPoints = []

    # Create Map
    map = new google.maps.Map(canvas, mapOptions)
    bounds = new google.maps.LatLngBounds()

    @_handleMapClick map

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
        icon: @markerUrl('gmaps_marker_1')

      infowindow = new (google.maps.InfoWindow)({ maxWidth: 200 })
      contentString =
        # if is organization
        if not markerData.organization_display_name
          HandlebarsTemplates['map_info_window_organization'](markerData)
        # if multiple offer locations exist for that marker
        else if markerData.ids[1] != undefined
          HandlebarsTemplates['map_info_window_multiple'](
            new Clarat.GMaps.Cell.MultipleOfferWindow(markerData)
          )
        # if a single offer exists for that location
        else
          HandlebarsTemplates['map_info_window_offer'](markerData)

      infowindow.setContent contentString

      includedPoints.push markerPosition
      bounds.extend markerPosition

      # Bind Event Listeners To Marker
      @_bindMapsEvents map, marker, markerData, canvas, infowindow
      @_bindMarkerToResults marker, markerData

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

  @_handleMapClick: (map) ->
    google.maps.event.addListener(
      map, 'click', ->
        $('#map-container').trigger 'Clarat.GMaps::MapClick'
    )

  # Event bindings for a single marker inside a map
  @_bindMapsEvents: (map, marker, markerData, canvas, infowindow) ->

    google.maps.event.addListener(marker, 'click', ->
      map.setCenter marker.getPosition()
      infowindow.open(map, marker)
    )

    google.maps.event.addListener(
      marker, 'mouseover', ->
        $('#map-container').trigger(
          'Clarat.GMaps::MarkerMouseOver', [marker, markerData]
        )
    )

    google.maps.event.addListener(
      marker, 'mouseout', ->
        $('#map-container').trigger(
          'Clarat.GMaps::MarkerMouseOut', [marker, markerData]
        )
    )

  @_bindMarkerToResults: (marker, markerData) ->
    for offerID in markerData.ids
      $("#result-offer-#{offerID}").data('marker', marker)
