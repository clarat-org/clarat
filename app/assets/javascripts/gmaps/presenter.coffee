# Google Maps Display - Presenter
class Clarat.GMaps.Presenter extends ActiveScript.Presenter
  # canvas - the DOM element that functions as the map canvas
  # data - the DOM element that provides additional information for the map:
  #   markers - a list of markers that are to be set in the map
  #   options - map API options that will be transmitted to Google
  #   ui - user interface options for internal use (like autoenlarge)
  constructor: (@markers) ->
    super()
    @canvas = document.getElementById('map-canvas')
    @data = $('#map-data')
    @markers = @data.data('markers') unless @markers
    @mapOptions = @data.data('options') or {}
    @uiOptions = @data.data('ui') or {}
    @infowindow = new (google.maps.InfoWindow)({ maxWidth: 200 })
    return unless @markers

    # For Issue #783
    $('body').addClass 'has-google-map'

    @currentMap = Clarat.GMaps.Operation.ConstructMap.run(
      @markers, @canvas, @mapOptions, @uiOptions)
    @handleMapResize()

    @mapModal = new Clarat.MapModal.Presenter # handles Map Button

  CALLBACKS:
    '#map-container':
      mousedown: 'handleMapClick'
      'Clarat.GMaps::MarkerClick': 'handleMarkerClick'
      'Clarat.GMaps::MarkerMouseOver': 'handleMarkerMouseOver'
      'Clarat.GMaps::MarkerMouseOut': 'handleMarkerMouseOut'
      'Clarat.GMaps::MapClick': 'handleNativeMapClick'
      'Clarat.GMaps::Resize': 'handleMapResize'
      'Clarat.MapModal::Close': 'handleClosingModal'
    '.JS-trigger-marker':
      mouseover: 'handleResultMouseOver'
      mouseout: 'handleResultMouseOut'

  # Expand map to include all currently contained markers
  handleMapResize: =>
    google.maps.event.trigger @currentMap.instance, 'resize'

    # For more than one marker, resize to fit all of them
    if @currentMap.includedPoints.length > 1
      @currentMap.instance.fitBounds @currentMap.bounds

    # For a single marker, center on that one and zoom out
    else
      @currentMap.instance.setCenter(
        @currentMap.bounds.getCenter()
      )
      @currentMap.instance.setZoom 15

  # called by library internally; listener set in Operations.ConstructMap
  handleMarkerClick: (event, marker, markerData) =>
    # render template for marker's info window
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

    @currentMap.instance.setCenter marker.getPosition()
    @infowindow.close()
    @infowindow.setContent contentString
    @infowindow.open @currentMap.instance, marker

  handleMarkerMouseOver: (_event, marker, markerData) =>
    for id in markerData.ids
      $("#result-offer-#{id} .Listing-results__offer")
        .addClass('Listing-results__offer--highlighted')
    @_switchMarkerImage(marker, 'gmaps_marker_highlighted')

  handleMarkerMouseOut: (_event, marker, markerData) =>
    for id in markerData.ids
      $("#result-offer-#{id} .Listing-results__offer")
        .removeClass('Listing-results__offer--highlighted')
    @_switchMarkerImage(marker, 'gmaps_marker_1')

  handleResultMouseOver: (event) =>
    marker = $(event.currentTarget).data('marker')
    @_switchMarkerImage(marker, 'gmaps_marker_highlighted') if marker

  handleResultMouseOut: (event) =>
    marker = $(event.currentTarget).data('marker')
    @_switchMarkerImage(marker, 'gmaps_marker_1') if marker

  # called by library internally; listener set in Operations.ConstructMap
  handleNativeMapClick: (e) =>
    @infowindow.close()

  handleMapClick: (e) =>
    if @uiOptions['autoenlarge'] and @uiOptions['autoenlarge'] is true
      @mapModal.modal.popup('show')
      @currentMap.instance.setOptions({ draggableCursor: null })

  handleClosingModal: (e) =>
    if @uiOptions['autoenlarge'] and @uiOptions['autoenlarge'] is true
      @currentMap.instance.setOptions({ draggableCursor: 'pointer' })


  ### PRIVATE (ue) ###


  _switchMarkerImage: (marker, state) ->
    marker.setIcon(
      Clarat.GMaps.Operation.ConstructMap.markerUrl(state)
    )



### ---------------- cut here ---------------- ###


### TODO: ALSO NEEDS REFACTORING: (deprecated as is) ###

Clarat.GMaps.PlacesAutocomplete =
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
            $(document).trigger 'Clarat::GMaps::placesAutocompleteTriggered'
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
