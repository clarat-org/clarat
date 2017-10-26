Clarat.HandleWorldSelectOverlay = {}
class Clarat.HandleWorldSelectOverlay.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '#top-bar__world-select-button':
      click: 'handle'

  handle: (e) =>

    $('.nav-lang__button').removeClass('is-active')
    $('.nav-lang__list').removeClass('nav-lang__list--vertical')

    btn = $(e.target)

    btn.attr 'aria-expanded', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

    btn.next('.top-bar__world-select-overlay').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

$(document).ready ->
  new Clarat.HandleWorldSelectOverlay.Presenter

