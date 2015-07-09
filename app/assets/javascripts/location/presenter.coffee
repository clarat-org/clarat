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


  CALLBACKS:
    '.JS-Geolocation__display':
      place_changed: 'handlePlaceChanged'
      focus: 'handleFocussedLocationInput'
      blur: 'handleBlurredLocationInput'
    '.JS-Geolocation__prompt':
      click: 'handleBrowserLocationPromptClick'
    '.JS-Geolocation__remove':
      click: 'handleRemoveLocationByBrowserClick'


  ## Simple place change by input or Google Places Autocomplete selection

  # Geolocation Display Input has new location (triggered by GMaps)
  handlePlaceChanged: (event) =>
    Clarat.Location.Concept.RequestGeolocationForString.run(
      @searchLocationInput.val(), @updateCurrentLocation
    )


  ## Place Change by querying browser location

  # Geolocation Display Input focussed
  handleFocussedLocationInput: (event) =>
    unless @preventLocationByBrowserPrompt
      # Clear remaining timeouts in case of rapid clicking
      clearTimeout @promptTimeout

      # Open prompt to use browser's location
      if @searchLocationInput.val() isnt I18n.t('conf.current_location')
        @render '.JS-Geolocation__wrapper', 'location_by_browser_prompt',
          content: I18n.t('js.geolocation.get')
        , method: 'append'

  # Geolocation Display Input left
  handleBlurredLocationInput: (event) =>
    # User has one second after leaving focus to click the prompt
    @promptTimeout = setTimeout @removePrompt, 1000

  # Prompt clicked: Find out browser's geolocation
  handleBrowserLocationPromptClick: (event) =>
    # Prompt was clicked, doesn't need to be timed out anymore
    clearTimeout @promptTimeout

    # Inform user that the request is now pending
    @render '.JS-Geolocation__prompt', 'location_by_browser_waiting',
      content: I18n.t('js.geolocation.waiting')
    , method: 'replaceWith'

    # Request Beolocation from browser
    if navigator.geolocation
      # Timeout because the default doesn't work in all browsers
      @geolocationTimeout =
        setTimeout(@handleBrowserGeolocationRequestError, 10000)

      navigator.geolocation.getCurrentPosition(
        @handleBrowserGeolocationRequestSuccess,
        @handleBrowserGeolocationRequestError
      )
    else
      # Fallback for no geolocation
      @handleBrowserGeolocationRequestError('No JS Geolocation')

  # Browser returned an error while trying to find geolocation
  handleBrowserGeolocationRequestError: (error = 'Timeout') =>
    clearTimeout @geolocationTimeout
    console.log error

    # Inform user that something went wrong
    @render '.JS-Geolocation__prompt', 'location_by_browser_error',
      content: I18n.t('js.geolocation.error')
    , method: 'replaceWith'

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

    Clarat.Location.Concept.TurnInputIntoMyLocationDisplay.run(
      @currentLocation
    )

    @render '.JS-Geolocation__display', 'location_by_browser_remove', {},
      method: 'after'

  # Remove button for the display of "using current location" clicked.
  handleRemoveLocationByBrowserClick: (event) =>
    # Reset fields
    @removePrompt()

    Clarat.Location.Concept.TurnInputIntoMyLocationDisplay.revert()

    # Focus on display (without location prompt)
    @preventLocationByBrowserPrompt = true
    $('.JS-Geolocation__display').focus()
    @preventLocationByBrowserPrompt = false


  ### PRIVATE METHODS (ue) ###

  # Called when timeout over
  removePrompt: =>
    $('.JS-Geolocation__prompt').remove()

  # set new location and inform the outside
  updateCurrentLocation: (response) =>
    @currentLocation = response
    $(document).trigger 'Clarat.Location::NewLocation', @currentLocation


$(document).ready ->
  Clarat.Location.presenter = Clarat.Location.Presenter.get()
