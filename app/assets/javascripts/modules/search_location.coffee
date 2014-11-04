$(document).ready ->
  if $('.JS-Search-location').length
    $(document).on 'newGeolocation', updateLocationInput

updateLocationInput = ->
  unless readCookie('last_search_location')
    $('.JS-Search-location').attr 'value', document.Clarat.currentGeolocation
    $('.JS-Search-location-display').attr 'value', I18n.t('conf.current_location')
