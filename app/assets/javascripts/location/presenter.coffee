class Clarat.Location.Presenter extends ActiveScript.Presenter
  constructor: ->
    @searchLocationInput = $('.JS-Geolocation__display')
    return null unless @searchLocationInput.length

    super()

    @currentGeolocationByBrowser = false
    @currentLocation =
      query: @searchLocationInput.val()
      geoloc: $('#search_form_generated_geolocation')?.value ||
        I18n.t('conf.default_latlng') # default: middle of Berlin

    @onLoad()


  CALLBACKS:
    '.JS-Geolocation__display':
      place_changed: 'handlePlaceChanged'
      focus: 'handleFocussedLocationInput'
      blur: 'handleBlurredLocationInput'
    '.JS-Geolocation__prompt':
      click: 'handleRequestGeolocation'
    '.JS-Geolocation__remove':
      click: 'handleRemoveLocationByBrowserClick'
    '#new_search_form':
      submit: 'handleFormSubmit'
    document:
      'Clarat.Location::RequestGeolocation': 'handleRequestGeolocation'


  # Check if cookie had was saved to use "my location" and if so, use it again.
  onLoad: ->
    @startGarbageCollection()
    if @searchLocationInput.val() is I18n.t('conf.current_location')
      # Turn input into display field because we don't just want the string
      # "My Location" in there in plain text
      Clarat.Location.Operation.TurnInputIntoMyLocationDisplay.run(
        @currentLocation
      )

      # Act as if user requested their current geolocation, since they likely
      # still give us permission to use it
      @handleRequestGeolocation()

    if @searchLocationInput.val() is I18n.t('js.geolocation.fallback')
      Clarat.Location.Operation.TurnInputIntoMyLocationDisplay.revert()


  ## Simple place change by input or Google Places Autocomplete selection

  # Geolocation Display Input has new location (triggered by GMaps)
  handlePlaceChanged: (event) =>
    Clarat.Location.Operation.RequestGeolocationForString.run(
      @searchLocationInput.val(), @updateCurrentLocation
    )

  initMyLocationDisplay: (location) =>
    Clarat.Location.Operation.TurnInputIntoMyLocationDisplay.run(
      location
    )

  ## Place Change by querying browser location

  # Geolocation Display Input focussed
  handleFocussedLocationInput: (event) =>
    unless @preventLocationByBrowserPrompt or @promptIsInUse
      @promptIsInUse = true

      # Open prompt to use browser's location
      if @searchLocationInput.val() isnt I18n.t('conf.current_location') or searchLocationInput.val() isnt "Alexanderplatz, Berlin, Deutschland"
        @render '.JS-Geolocation__wrapper', 'location_by_browser_prompt',
          content: I18n.t('js.geolocation.get')
        , method: 'append'

  # Geolocation Display Input left
  handleBlurredLocationInput: (event) =>
    @promptIsInUse = false

  # Prompt clicked: Find out browser's geolocation
  handleRequestGeolocation: (event) =>
    # Prompt was clicked, doesn't need to be timed out anymore
    @promptIsInUse = true

    # Inform user that the request is now pending
    @render '.JS-Geolocation__prompt', 'location_by_browser_waiting',
      content: I18n.t('js.geolocation.waiting')
    , method: 'replaceWith'

    # Request Geolocation from browser
    if navigator.geolocation
      # Timeout because the geolocation query doesn't work in all browsers
      @geolocationTimeout =
        setTimeout(@handleBrowserGeolocationRequestError, 10000)

      navigator.geolocation.getCurrentPosition(
        @handleBrowserGeolocationRequestSuccess,
        @handleBrowserGeolocationRequestError
      )
    else
      # Fallback for no geolocation
      # @handleBrowserGeolocationRequestError('no_js_geolocation')
      @handleBrowserGeolocationRequestError(code: 4)

  # Browser returned an error while trying to find geolocation
  # Code reference:
  # 1 - User denied Geolocation
  # 2 - Position unavailable
  # 3 - Timeout
  # 4 - Browser doesn't support Geolocation (custom code)
  handleBrowserGeolocationRequestError: (error = code: 3) =>
    clearTimeout @geolocationTimeout

    # Inform user that we chose a fallback
    @render '.JS-Geolocation__wrapper', 'location_by_browser_fallback',
      content: I18n.t "js.geolocation.fallback_clarification.code#{error.code}"
    , method: 'append'

    # Set location to fallback
    $('#search_form_search_location').val I18n.t('js.geolocation.fallback')

  # Browser returned with a geolocation
  handleBrowserGeolocationRequestSuccess: (position) =>
    clearTimeout @geolocationTimeout

    # Pending info not needed anymore
    @removePrompt()

    # save geo info
    @currentGeolocationByBrowser = true
    @updateCurrentLocation
      query: I18n.t('conf.current_location')
      geoloc: "#{position.coords.latitude},#{position.coords.longitude}"

    @initMyLocationDisplay(@currentLocation)

  # Remove button for the display of "using current location" clicked.
  handleRemoveLocationByBrowserClick: (event) =>
    # Reset fields
    @removePrompt()

    Clarat.Location.Operation.TurnInputIntoMyLocationDisplay.revert()

    # Focus on display (without location prompt)
    @preventLocationByBrowserPrompt = true
    $('.JS-Geolocation__display').focus()
    @preventLocationByBrowserPrompt = false

  handleFormSubmit: (event) =>
    if $('#search_form_search_location').val() == ""
      $('#search_form_search_location').blur() # always loose focus
      $(document).trigger 'Clarat.Location::RequestGeolocation'
      @stopEvent event


  ### PRIVATE METHODS (ue) ###

  # Called when timeout over
  removePrompt: =>
    $('.JS-Geolocation__prompt').remove()

  # set new location and inform the outside
  updateCurrentLocation: (response) =>
    @currentLocation = response
    Clarat.Location.Operation.SaveToCookie.run(response)
    $(document).trigger 'Clarat.Location::NewLocation', @currentLocation

  # Garbage collection: regularly check, whether an existing prompt is visiblei
  # and may be removed
  startGarbageCollection: ->
    setInterval(@tickGarbageCollection, 4000)
  tickGarbageCollection: =>
    if $('.JS-Geolocation__prompt') and not @promptIsInUse
      @removePrompt()

$(document).ready ->
  Clarat.Location.presenter = new Clarat.Location.Presenter
