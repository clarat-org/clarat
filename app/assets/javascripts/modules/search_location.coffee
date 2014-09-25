$(document).ready ->
  if $('.JS-Search-location').length
    updateLocationInput()
    $(document).on 'newGeolocation', updateLocationInput

updateLocationInput = ->
  $('.JS-Search-location').attr 'value', document.Clarat.currentGeolocation