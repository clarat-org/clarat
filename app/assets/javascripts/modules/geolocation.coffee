Clarat.getGeolocation = ->
  navigator.geolocation.getCurrentPosition (position) ->
    Clarat.currentGeolocationByBrowser = true
    Clarat.currentGeolocation =
      "#{position.coords.latitude},#{position.coords.longitude}"
    $(document).trigger 'newGeolocation'

handleBlurredLocationInput = (e) ->
  requestedLoc = e.target.value
  unless requestedLoc is I18n.t('conf.current_location')
    $.get "/search_locations/#{encodeURIComponent(requestedLoc)}.json", (r) ->
      Clarat.currentGeolocationByBrowser = false
      Clarat.currentGeolocation = r.geoloc
      $(document).trigger 'newGeolocation'

$(document).ready ->
  Clarat.currentGeolocation =
    document.getElementById('search_form_generated_geolocation')?.value ||
    I18n.t('conf.default_latlng') # default: middle of Berlin
  Clarat.currentGeolocationByBrowser = false

  Clarat.getGeolocation()

  searchLocInput = $('.JS-Search-location-display')
  if searchLocInput.length
    searchLocInput.on 'blur', handleBlurredLocationInput
