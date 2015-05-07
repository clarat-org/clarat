ready = ->
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
    Clarat.placesAutocomplete =
      new google.maps.places.Autocomplete location_input, opts

    # register event listener that pushes to GA when field is changed by user
    google.maps.event.addListener Clarat.placesAutocomplete, 'place_changed', ->
      Clarat.Analytics.placesAutocompleteChanged()

$(document).ready ready
$(document).on 'page:load', ready
