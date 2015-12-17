Clarat.StickyMobileNav = {}
class Clarat.StickyMobileNav.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      resize: 'handler'
      load: 'handler'

  handler: ()  =>

    wrap = $(window)
    smartphone = ($(window).width() < 501)
    $homeTemplate = $("body.template--pages-home").length
    bannerAndNavHeight = $('.nav-lang').outerHeight() + $('.nav-welt--notstart').outerHeight()
    distributor = $('.Distributor__search-form')

    if $homeTemplate
      return

    console.log bannerAndNavHeight

    if smartphone
      wrap.on "scroll", ->

        if $(this).scrollTop() > bannerAndNavHeight
          distributor.addClass 'is-fixed'
        else
          distributor.removeClass 'is-fixed'


$(document).ready ->
  new Clarat.StickyMobileNav.Presenter
