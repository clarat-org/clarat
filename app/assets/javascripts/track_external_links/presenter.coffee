# Track clicks on external links via Google Analytic's recommended
# trackOutboundLink script (included inline for global scope)
Clarat.TrackExternalLinks = {}
class Clarat.TrackExternalLinks.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    'a':
      click: 'trackClick'

  trackClick: (e) =>

    $(e).each ->
      a = new RegExp('/' + window.location.host + '/')
      if !a.test(@href)
        window.trackOutboundLink(e.target.href)

$(document).ready ->
  new Clarat.TrackExternalLinks.Presenter
