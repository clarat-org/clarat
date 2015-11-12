Clarat.StickyMobileNav = {}
class Clarat.StickyMobileNav.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      resize: 'handler'
      load: 'handler'

  handler: ()  =>


    wrap = $(window)
    smartphone = ($(window).width() < 480)
    $homeTemplate = $("body.template--pages-home").length
    bannerHeight = $('.Banner').height()
    header = $('.header-main')

    if $homeTemplate
      return

    if smartphone
      wrap.on "scroll", ->

        if $(this).scrollTop() > bannerHeight
          header.addClass 'is-fixed'
        else
          header.removeClass 'is-fixed'


$(document).ready ->
  new Clarat.StickyMobileNav.Presenter

