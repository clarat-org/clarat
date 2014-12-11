document.Clarat.getGeolocation = ->
  navigator.geolocation.getCurrentPosition (position) ->
    document.Clarat.currentGeolocationByBrowser = true
    document.Clarat.currentGeolocation =
      "#{position.coords.latitude},#{position.coords.longitude}"
    $(document).trigger 'newGeolocation'

handleBlurredLocationInput = (e) ->
  requestedLoc = e.target.value
  unless requestedLoc is I18n.t('conf.current_location')
    $.get "/search_locations/#{encodeURIComponent(requestedLoc)}.json", (r) ->
      document.Clarat.currentGeolocationByBrowser = false
      document.Clarat.currentGeolocation = r.geoloc
      $(document).trigger 'newGeolocation'

$(document).ready ->
  document.Clarat.currentGeolocation =
    document.getElementById('search_form_generated_geolocation')?.value ||
    I18n.t('conf.default_latlng') # default: middle of Berlin
  document.Clarat.currentGeolocationByBrowser = false

  document.Clarat.getGeolocation()

  searchLocInput = $('.JS-Search-location-display')
  if searchLocInput.length
    searchLocInput.on 'blur', handleBlurredLocationInput
