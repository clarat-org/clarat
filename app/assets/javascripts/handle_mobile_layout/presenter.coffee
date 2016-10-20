Clarat.HandleMobileLayout = {}
class Clarat.HandleMobileLayout.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      resize: 'init'
    document:
      'Clarat.Search::NewResults': 'init'
    '#top-bar__world-select-button':
      click: 'handleWorldSelectOverlay'

  init: () =>

    if $('body.template--offers-index').length
      @repositionElements()

  repositionElements: () =>

    console.log "repositionElements fired"

    if ($(window).width() > 750)

      console.log "> 750"

      $('.aside-standard__container').appendTo $('.aside-standard')
      $('#map-container').trigger 'Clarat.GMaps::Resize'

      $('.result-orders').prependTo $('.Listing-results')

    else

      console.log "< 750"

      $('.aside-standard__container').appendTo $('#tab_map')
      $('#map-container').trigger 'Clarat.GMaps::Resize'

      $('.result-order').prependTo $('.filter-form')

  handleWorldSelectOverlay: (e) =>

    btn = $(e.target)

    btn.attr 'aria-expanded', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

    btn.next('.top-bar__world-select-overlay').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

$(document).on 'ready', ->
  new Clarat.HandleMobileLayout.Presenter

