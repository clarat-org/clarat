Clarat.HandleMobileLayout = {}
class Clarat.HandleMobileLayout.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      resize: 'init'
      load: 'init'
    '#top-bar__world-select-button':
      click: 'handleWorldSelectOverlay'

  init: () =>

    if $('.template--offers-index').length
      @repositionSelect()

  repositionSelect: () =>

    if ($(window).width() > 750)

      console.log "original place select"
#      console.log $('.result-order')

    else

      console.log "new place select"
#      console.log $('.result-order')

  handleWorldSelectOverlay: (e) =>

    btn = $(e.target)

    btn.attr 'aria-expanded', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

    btn.next('.top-bar__world-select-overlay').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

$(document).on 'ready', ->
  new Clarat.HandleMobileLayout.Presenter

