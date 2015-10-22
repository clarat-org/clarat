Clarat.StickySidebar = {}

class Clarat.StickySidebar.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      load: 'stickSidebar'
      resize: 'stickSidebar'

  stickSidebar: =>
    if $('body.template--offers-index').length

      $sticky = $(".template--offers-index").find(".aside-standard")
      $footer = $(".footer-main .nav-legal__list")
      stickyHeight = $sticky.height()
      $container = $('.content-main--offers-index')
      $header = $('.header-main')
      desktop = $(document).innerWidth() >= 750
      ie = $('html.ie11').length || $('html.ie10').length

      $container.css('min-height', stickyHeight)

      if !ie


        if desktop

          $sticky.css('position', 'absolute')

          if !!$sticky.offset()
            stickyTop = $sticky.offset().top

            $(window).scroll ->

              footerInViewport = withinviewport $footer
              windowTop = $(window).scrollTop()

              if stickyTop < windowTop

                top = if footerInViewport then -210 else 0

                $sticky.css
                  position: 'fixed'
                  top: if withinviewport $header then 0 else top
                  width: '27.8%'

              else
                $sticky.css('position', 'absolute')

        else
            $sticky.css('position', 'relative')

$(document).ready ->
  new Clarat.StickySidebar.Presenter



