#

Clarat.MobileNav = {}
class Clarat.MobileNav.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      load: 'init'
      resize: 'init'

  init: () =>

    if ($('body').width() <= 768)
      $('.nav-main').attr 'aria-hidden', 'true'
      $('#header-main__nav-main-trigger')
          .unbind 'click'
          .bind 'click', this.toggleMenu
    else
      $('#header-main__nav-main-trigger').unbind 'click'
      $('.nav-main').attr 'aria-hidden', 'false'

  toggleMenu: () =>
    # $('.nav-lang__list').toggleClass('nav-lang__list--vertical')
    # $('.nav-lang__button').toggleClass('is-active')
    $('.nav-main').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'



$(document).on 'ready', ->
  new Clarat.MobileNav.Presenter

