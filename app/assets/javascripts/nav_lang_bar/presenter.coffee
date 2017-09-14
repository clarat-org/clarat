# Init nav lang bar vertical menu if mobile-ish

Clarat.NavLangBar = {}
class Clarat.NavLangBar.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      load: 'init'
      resize: 'init'

  init: () =>

    if ($('body').width() <= 768)
      $('.nav-lang__button')
        .unbind 'click'
        .bind 'click', this.toggleMenu
    else
      $('.nav-lang__button').unbind 'click'

  toggleMenu: () =>
    $('.nav-lang__list').toggleClass('nav-lang__list--vertical')
    $('.nav-lang__button').toggleClass('is-active')
    $('.top-bar__world-select-button').attr('aria-expanded', 'false')
    $('.top-bar__world-select-overlay').attr('aria-hidden', 'true')

$(document).on 'ready', ->
  new Clarat.NavLangBar.Presenter

