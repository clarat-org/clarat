stickyMobileNav = ->

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

$(document).on 'page:load', stickyMobileNav
$(document).on 'ajax_loaded', stickyMobileNav
$(document).ready stickyMobileNav
$(window).resize stickyMobileNav
