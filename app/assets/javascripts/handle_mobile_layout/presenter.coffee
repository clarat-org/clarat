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
    console.log "init called"

    if $('body.template--offers-index').length
      @repositionElements()

  repositionElements: () =>

    if ($(window).width() > 750)

      console.log "original place select"
      $('.aside-standard__container').appendTo $('.aside-standard')
      $('#map-container').trigger 'Clarat.GMaps::Resize'

    else

      console.log "new place select"
      $('.aside-standard__container').appendTo $('#tab_map')
      $('#map-container').trigger 'Clarat.GMaps::Resize'

# console.log $('.result-order')

  handleWorldSelectOverlay: (e) =>

    btn = $(e.target)

    btn.attr 'aria-expanded', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

    btn.next('.top-bar__world-select-overlay').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

$(document).on 'ready', ->
  new Clarat.HandleMobileLayout.Presenter

