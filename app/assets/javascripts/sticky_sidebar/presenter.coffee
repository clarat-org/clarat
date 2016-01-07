Clarat.StickySidebar = {}

class Clarat.StickySidebar.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      load: 'stickSidebar'
      resize: 'stickSidebar'

  stickSidebar: =>
    if $('body.template--offers-index').length

      $sticky = $(".template--offers-index").find(".aside-standard")
      stickyHeight = $sticky.height()
      $container = $('.content-main--offers-index')
      desktop = $(document).width() >= 750

      if desktop

        $(window).scroll()

        if !!$sticky.offset()
          stickyTop = $sticky.offset().top

          # Don't activate if sidebar is higher than current viewport
          if (stickyHeight > $('body').outerHeight())
            return

          $container.css('min-height', stickyHeight)

          $(window).scroll ->

            footerInViewport = $(".nav-legal__list:in-viewport").length
            windowTop = $(window).scrollTop()

            if stickyTop < windowTop

              top = if footerInViewport then -210 else 0

              headerInViewport = $(".header-main:in-viewport").length

              $sticky.css
                position: 'fixed'
                top: if headerInViewport then 0 else top
#                width: '27.8%'

            else
              $sticky.css('position', 'absolute')

      else
        $sticky.css('position', 'relative')

$(document).ready ->
  new Clarat.StickySidebar.Presenter