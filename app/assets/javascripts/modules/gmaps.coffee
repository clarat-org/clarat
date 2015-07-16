Clarat.GMaps =
  loaded: false

  initialize: -> # callback for when maps script is loaded from google
    Clarat.GMaps.loaded = true

    # places autocomplete always fires
    Clarat.GMaps.PlacesAutocomplete.initialize()

    # initialize in case an ajax request already returned (unlikely)
    Clarat.GMaps.Map.initialize()

    # initialize map again each time an ajax request brought new information
    # $(document).on 'ajax_done', Clarat.GMaps.Map.initialize
    # $(document).on 'ActiveScript::PageChange', Clarat.GMaps.Map.initialize

  Map:
    initialize: (markers) ->
      canvas = document.getElementById('map-canvas')
      markers = $('#map-data').data('markers') unless markers
      infowindow = new (google.maps.InfoWindow)({ maxWidth: 200 })
      includedPoints = []

      if markers
        # Create Map
        mapOptions =
          scrollwheel: false
        map = new google.maps.Map(canvas, mapOptions)
        bounds = new google.maps.LatLngBounds()

        # Create Markers
        for key, markerData of markers
          continue unless markerData.position
          markerPosition = new google.maps.LatLng(
            markerData.position.latitude,
            markerData.position.longitude
          )
          marker = new google.maps.Marker
            position: markerPosition
            map: map
            icon: image_path('gmaps_marker_1.svg')

          includedPoints.push markerPosition
          bounds.extend markerPosition

          # Bind Event Listeners To Marker
          Clarat.GMaps.Map.bindMapsEvents map, marker, markerData, infowindow
          Clarat.GMaps.Map.bindMarkerToResults marker, markerData, infowindow

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

        # Save data for later use
        Clarat.currentMap = {}
        Clarat.currentMap.instance = map
        Clarat.currentMap.bounds = bounds
        Clarat.currentMap.includedPoints = includedPoints

        Clarat.GMaps.Map.setMapBounds()

    setMapBounds: ->
      # Expand Map to Include All Markers
      if Clarat.currentMap.includedPoints.length > 1
        Clarat.currentMap.instance.fitBounds Clarat.currentMap.bounds
      else
        Clarat.currentMap.instance.setCenter(
          Clarat.currentMap.bounds.getCenter()
        )
        Clarat.currentMap.instance.setZoom 15


    bindMapsEvents: (map, marker, markerData, infowindow) ->
      if not markerData.organization_display_name # if is organization
        contentString =
          HoganTemplates['map_info_window_organization'].render(markerData)
      else if markerData.ids[1] != undefined
        contentString =
          HoganTemplates['map_info_window_multiple'].render
            title: I18n.t 'js.map_info_window_multiple.title'
            text: I18n.t 'js.map_info_window_multiple.text'
            anchor: I18n.t 'js.map_info_window_multiple.anchor'
            url: Clarat.GMaps.Map.generate_exact_search_url markerData.position
      else
        contentString =
          HoganTemplates['map_info_window_offer'].render markerData

      google.maps.event.addListener marker, 'click', (event) ->
        map.setCenter marker.getPosition()
        infowindow.close()
        infowindow.setContent contentString;
        infowindow.open map, this

      google.maps.event.addListener map, 'click', (event) ->
        infowindow.close()

    generate_exact_search_url: (position) ->
      location.origin + location.pathname + $.query.set(
        'search_form[generated_geolocation]',
        "#{position.latitude},#{position.longitude}"
      ).set(
        'search_form[exact_location]', 't'
      ).toString()

    bindMarkerToResults: (marker, markerData) ->
      for offerID in markerData.ids
        $("#result-offer-#{offerID}").data('marker', marker)



  PlacesAutocomplete:
    initialize: ->
      location_input = document.getElementById('search_form_search_location')
      if location_input
        # autocomplete settings
        opts =
          bounds: new google.maps.LatLngBounds(
            new google.maps.LatLng(53, 14),
            new google.maps.LatLng(52, 12.5)
          )
          types: ['geocode']
          language: 'de'
          componentRestrictions:
            country: 'de'

        # instantiate autocomplete field
        Clarat.GMaps.PlacesAutocomplete.instance =
          new google.maps.places.Autocomplete location_input, opts

        # register event listener that pushes to GA when field is changed
        google.maps.event.addListener(
          Clarat.GMaps.PlacesAutocomplete.instance, 'place_changed', ->
            Clarat.Analytics.placesAutocompleteChanged()
        )

        # Hack to not immediately submit when user tries to select a location by
        # pressing enter on the input field.
        # See http://stackoverflow.com/a/12275591/784889
        $('#search_form_search_location').keydown (e) ->
          return false if (e.which == 13 && $('.pac-container:visible').length)

        # When place_changed is fired, also fire the event on the form element,
        # so other scripts can hook into that
        google.maps.event.addListener(
          Clarat.GMaps.PlacesAutocomplete.instance, 'place_changed',
          -> $('#search_form_search_location').trigger 'place_changed'
        )

        # If category links exist: event listener on input change to update them
        if $('.nav-sections__list').length
          $('#search_form_search_location').on(
            'input', Clarat.GMaps.PlacesAutocomplete.updateCategoryLinks)
          $('#search_form_generated_geolocation').on(
            'input', Clarat.GMaps.PlacesAutocomplete.updateCategoryLinks)
          google.maps.event.addListener(
            Clarat.GMaps.PlacesAutocomplete.instance, 'place_changed',
            Clarat.GMaps.PlacesAutocomplete.updateCategoryLinks
          )

          Clarat.GMaps.PlacesAutocomplete.updateCategoryLinksPeriodically()


    ### Start Page needs category links updated from autocomplete changes ###

    updateCategoryLinksPeriodically: ->
      # in 1 sec interval to catch other changes
      categoryUpdateInterval =
        setInterval Clarat.GMaps.PlacesAutocomplete.updateCategoryLinks, 1000
      $(document).on 'page:before-change', ->
        clearInterval categoryUpdateInterval

    updateCategoryLinks: ->
      search_location = $('#search_form_search_location').val()
      generated_geolocation = $('#search_form_generated_geolocation').val()

      for link in $('.nav-sections__listitem a')
        originalHref = link.href
        [originalBase, originalParams] = originalHref.split '?'
        $.query.spaces = true
        changedHref =
          $.query.parseNew originalParams
            .set 'search_form[search_location]', search_location
            .set 'search_form[generated_geolocation]', generated_geolocation
            .toString()
            .replace /%2B/g, '%20'
            # ^ fix $.query tendency to convert space to plus

        link.href = originalBase + changedHref
