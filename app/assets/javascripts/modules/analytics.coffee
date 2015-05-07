Clarat.Analytics =
  placesAutocompleteChanged: ->
    place = Clarat.placesAutocomplete.getPlace()
    if place
      ga 'send', 'event', 'field', 'changed', 'places_autocomplete',
        metric1: place.formatted_address
