Clarat.HandleWorldSelectOverlay = {}
class Clarat.HandleWorldSelectOverlay.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '#top-bar__world-select-button':
      click: 'handle'

  handle: (e) =>

    btn = $(e.target)

    btn.attr 'aria-expanded', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

    btn.next('.top-bar__world-select-overlay').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

$(document).on 'ready', ->
  new Clarat.HandleWorldSelectOverlay.Presenter

