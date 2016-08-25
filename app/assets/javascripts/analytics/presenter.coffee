# Module for handling Google Analytics related events

Clarat.Analytics = {}
class Clarat.Analytics.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    'a[href^="http"]':
      click: 'trackClick'
    document:
      'Clarat::GMaps::placesAutocompleteTriggered': 'detectPlacesAutocompleteTriggered'
      'page:change' : 'handlePageChange'


  trackClick: (e) =>
    $(e).each =>
      @trackOutboundLink(e.target.href)


  trackOutboundLink: (url) =>
    ga? 'send', 'event', 'outbound', 'click', url,
      'transport': 'beacon'
      'hitCallback': ->
        document.location = url
        return


  detectPlacesAutocompleteTriggered: () =>
    place = Clarat.GMaps.PlacesAutocomplete.instance.getPlace()

    if place
      ga?(
        'send', 'event', 'field', 'changed', 'places_autocomplete',
        metric1: place.formatted_address
      )


  handlePageChange: () =>
    if window._gaq?
      _gaq?.push ['_trackPageview']

    else if window.pageTracker?
      pageTracker._trackPageview()



$(document).ready ->
  new Clarat.Analytics.Presenter
