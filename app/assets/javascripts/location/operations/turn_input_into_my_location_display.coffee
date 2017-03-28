class Clarat.Location.Operation.TurnInputIntoMyLocationDisplay
  @run: () ->
    # Visibly show user that we are now using hidden coordinates and prevent
    # them from just typing over the current_location string in the display
    $('.JS-Geolocation__display').attr 'disabled', true

    $('.JS-Geolocation__display').after(
      HandlebarsTemplates['location_by_browser_remove']()
    )

  @revert: ->
    $('.JS-Geolocation__input').val ''
    $('.JS-Geolocation__display').val ''
    $('.JS-Geolocation__display').attr 'disabled', false
    $('.JS-Geolocation__remove').remove()
