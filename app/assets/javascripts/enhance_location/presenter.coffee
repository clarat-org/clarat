# For #936: Handle the case of empty location input
Clarat.enhanceLocation = {}

class Clarat.enhanceLocation.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '#new_search_form':
      submit: 'submitHandler'
    document:
      'Clarat.Location::GeolocationRequestError': 'handleGeolocationRequestError'

  submitHandler: (e) =>

    if $('#search_form_search_location').val() == ""
      e.preventDefault()
      $(document).trigger 'Clarat.Location::RequestGeolocation'

  handleGeolocationRequestError: () =>
    # German text "Wir schlagen vor hier zu suchen: 'Berlin-Alexanderplatz'. Wenn du woanders suchen willst gib hier eine andere Adresse, Stadt oder Postleitzahl ein."
    fallbackClarification =  I18n.t('js.geolocation.fallback_clarification')
    fallbackLocation = 'Alexanderplatz, Berlin, Deutschland'

    $('#search_form_search_location').val fallbackLocation

    # Inform user that chose Berlin Alexanderplatz
    @render '.JS-Geolocation__prompt', 'location_by_browser_fallback',
      content: fallbackClarification
    , method: 'replaceWith'

$(document).ready ->
  new Clarat.enhanceLocation.Presenter
