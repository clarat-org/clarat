# # Geolocation Display Input focussed
# handleFocussedLocationInput = (e) ->
#   # Clear remaining timeouts in case of rapid clicking
#   clearTimeout Clarat.geolocationPromptTimeout
#
#   # Open prompt to use browser's location
#   unless $('.JS-Geolocation__display').attr('value') is
#          I18n.t('conf.current_location')
#     $(e.target.parentElement).append HoganTemplates['geolocation_get'].render(
#       content: I18n.t('js.geolocation.get')
#     )
#
#     $('.JS-Geolocation__prompt').on 'click', requestUsersGeolocation
#
# # Geolocation Display Input left
# handleBlurredLocationInput = (e) ->
#   # User has one second after leaving focus to click the prompt
#   Clarat.geolocationPromptTimeout = setTimeout 'Clarat.removePrompt()', 1000
#
#   # request coordinates for entered String
#   requestedLoc = e.target.value
#   if requestedLoc isnt I18n.t('conf.current_location') and
#      requestedLoc isnt ''
#     Clarat.currentGeolocationByBrowser = false
#     Clarat.getCurrentLocation requestedLoc, (r) ->
#       # if there was still no location request
#       unless Clarat.currentGeolocationByBrowser
#         Clarat.currentGeolocation = r.geoloc
#         $(document).trigger 'newGeolocation'
#
# Clarat.getCurrentLocation = (requestedLocation, cb) ->
#   unless cb?
#     cb = (response) ->
#       Clarat.currentLocation = response
#       Clarat.currentGeolocation = response.geoloc
#       $(document).trigger 'newGeolocation'
#
#   console.log requestedLocation
#   $.get "/search_locations/#{encodeURIComponent(requestedLocation)}.json", cb
#
# # Prompt clicked: Find out browser's geolocation
# requestUsersGeolocation = ->
#   # Prompt was clicked, doesn't need to be timed out anymore
#   clearTimeout Clarat.geolocationPromptTimeout
#
#   # Inform user that the request is now pending
#   $('.JS-Geolocation__prompt').replaceWith(
#     HoganTemplates['geolocation_waiting'].render(
#       content: I18n.t('js.geolocation.waiting')
#     )
#   )
#
#   if navigator.geolocation
#     # Timeout because the default doesn't work in all browsers
#     Clarat.geolocationTimeout =
#       setTimeout('Clarat.geolocationError("Timeout")', 10000)
#
#     navigator.geolocation.getCurrentPosition(
#       geolocationSuccess, Clarat.geolocationError
#     )
#   else
#     # Fallback for no geolocation
#     Clarat.geolocationError('No JS Geolocation')
#
# # Browser returned with a geolocation
# geolocationSuccess = (position) ->
#   clearTimeout Clarat.geolocationTimeout
#
#   # Pending info not needed anymore
#   Clarat.removePrompt()
#
#   # Set geo info to hidden field
#   Clarat.currentGeolocationByBrowser = true
#   Clarat.currentGeolocation =
#     "#{position.coords.latitude},#{position.coords.longitude}"
#   $(document).trigger 'newGeolocation'
#
#   # Visibly show user that we are now using hidden coordinates and prevent them
#   # from just typing over the current_location string in the display
#   $('.JS-Geolocation__input')[0].value = Clarat.currentGeolocation
#   $('.JS-Geolocation__display')[0].value = I18n.t('conf.current_location')
#   $('.JS-Geolocation__display').attr 'disabled', true
#   $('.JS-Geolocation__display').after(
#     HoganTemplates['geolocation_remove_button'].render()
#   )
#   # Give it a remove button
#   $('.JS-Geolocation__remove').on 'click', geolocationRemove
#
# # Remove button for the display of "using current location" clicked.
# geolocationRemove = (e) ->
#   # Reset fields
#   Clarat.removePrompt()
#   $('.JS-Geolocation__input')[0].value = ''
#   $('.JS-Geolocation__display')[0].value = ''
#   $('.JS-Geolocation__display').attr 'disabled', false
#   $('.JS-Geolocation__remove').hide()
#
#   # Focus on display (without location prompt)
#   $('.JS-Geolocation__display').off 'focus', handleFocussedLocationInput
#   $('.JS-Geolocation__display').focus()
#   $('.JS-Geolocation__display').on 'focus', handleFocussedLocationInput
#
# Clarat.removePrompt = ->
#   $('.JS-Geolocation__prompt').remove()
#
# # Browser returned an error while trying to find geolocation
# Clarat.geolocationError = (error) ->
#   clearTimeout Clarat.geolocationTimeout
#
#   # Inform user that something went wrong
#   $('.JS-Geolocation__prompt').replaceWith(
#     HoganTemplates['geolocation_error'].render(
#       content: I18n.t('js.geolocation.error')
#     )
#   )
#
#   console.log error
#
# # On load: Register display focus handlers.
# $(document).ready ->
#   Clarat.currentGeolocation =
#     document.getElementById('search_form_generated_geolocation')?.value ||
#     I18n.t('conf.default_latlng') # default: middle of Berlin
#   Clarat.currentGeolocationByBrowser = false
#
#   searchLocInput = $('.JS-Geolocation__display')
#   if searchLocInput.length
#     searchLocInput.on 'focus', handleFocussedLocationInput
#     searchLocInput.on 'blur', handleBlurredLocationInput
