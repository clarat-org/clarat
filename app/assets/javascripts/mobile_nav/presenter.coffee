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
          .attr 'aria-expanded', 'false'
          .unbind 'click'
          .bind 'click', this.toggle
    else
      $('#header-main__nav-main-trigger').unbind 'click'
      $('.nav-main').attr 'aria-hidden', 'false'

  toggle: (e) =>
    this.toggleMenu()
    $(e.target).attr 'aria-expanded', (i, attr) ->
      if attr == 'true' then 'false' else 'true'

  toggleMenu: () =>
    $('.nav-main').attr 'aria-hidden', (i, attr) ->
      if attr == 'true' then 'false' else 'true'



$(document).on 'ready', ->
  new Clarat.MobileNav.Presenter

