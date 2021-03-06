Clarat.PlacesAutocomplete = {}
class Clarat.PlacesAutocomplete.Presenter extends ActiveScript.Presenter
  CALLBACKS:
    '#search_form_search_location':
      keydown: 'handleKeyDown'
      input: 'updateCategoryLinks'
    '#search_form_generated_geolocation':
      input: 'updateCategoryLinks'

  constructor: ->
    location_input = document.getElementById('search_form_search_location')

    if location_input
      # autocomplete settings
      options =
        bounds: new google.maps.LatLngBounds(
          new google.maps.LatLng(53, 14),
          new google.maps.LatLng(52, 12.5)
        )
        types: ['geocode']
        language: 'de'
        componentRestrictions:
          country: 'de'

      # instantiate autocomplete field
      Clarat.PlacesAutocomplete.instance =
        new google.maps.places.Autocomplete location_input, options

      # MORE CALLBACKS

      # register event listener that pushes to GA when field is changed
      # When place_changed is fired, also fire the event on the form element,
      # so other scripts can hook into that
      google.maps.event.addListener(
        Clarat.PlacesAutocomplete.instance, 'place_changed',
        @handleGooglePlaceChanged
      )

      # If category links exist: event listener on input change to update them
      #if $('.nav-sections__list').length
        #@updateCategoryLinksPeriodically()

  # Hack to not immediately submit when user tries to select a location by
  # pressing enter on the input field.
  # See http://stackoverflow.com/a/12275591/784889
  handleKeyDown: (event) =>
    if (event.which == 13 && $('.pac-container:visible').length)
      return false

  handleGooglePlaceChanged: =>
    $(document).trigger(
      'Clarat::PlacesAutocomplete::placesAutocompleteTriggered'
    )

$(document).ready ->
  Clarat.PlacesAutocomplete.presenter = new Clarat.PlacesAutocomplete.Presenter
