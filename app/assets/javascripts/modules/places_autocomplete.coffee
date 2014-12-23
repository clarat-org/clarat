ready = ->
  location_input = document.getElementById('search_form_search_location')
  if location_input
    opts =
      bounds: new google.maps.LatLngBounds(
        new google.maps.LatLng(53, 14),
        new google.maps.LatLng(52, 12.5)
      )
      types: ['geocode']
      language: 'de'
      componentRestrictions:
        country: 'de'

    autocomplete = new google.maps.places.Autocomplete location_input, opts

$(document).ready ready
$(document).on 'page:load', ready
