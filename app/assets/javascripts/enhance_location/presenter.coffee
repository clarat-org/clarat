# DEPRECATED
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
      $('#search_form_search_location').blur()
      $(document).trigger 'Clarat.Location::RequestGeolocation'

  handleGeolocationRequestError: () =>

    # Inform user that we chose Berlin Alexanderplatz
    @render '.JS-Geolocation__wrapper', 'location_by_browser_fallback',
      content: fallbackClarification
    , method: 'append'

    # German text "Der Alexanderplatz in Berlin ist nicht in deiner Nähe? Dann gib hier bitte deine Adresse, PLZ oder Stadt ein."
    fallbackClarification =  I18n.t('js.geolocation.fallback_clarification')
    fallbackLocation = 'Alexanderplatz, Berlin, Deutschland'

    $('#search_form_search_location').val fallbackLocation



# $(document).ready ->
#   new Clarat.enhanceLocation.Presenter
