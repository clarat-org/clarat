$(document).ready ->
  if $('.JS-Search-location').length
    $(document).on 'newGeolocation', updateLocationInput

updateLocationInput = ->
  if Clarat.currentGeolocationByBrowser and not readCookie('last_search_location')
    $('.JS-Search-location').attr 'value', Clarat.currentGeolocation
    $('.JS-Search-location-display').attr 'value', I18n.t('conf.current_location')
