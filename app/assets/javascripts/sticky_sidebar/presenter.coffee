Clarat.StickySidebar = {}

class Clarat.StickySidebar.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      load: 'stickSidebar'
      resize: 'stickSidebar'

  stickSidebar: =>

    # Since aside is positioned absolute, prevent layout clashes with footer
    asideHeight = $('.aside-standard').height()
    orgininalContentHeight = $('.content-main').height()

    $('.content-main').height asideHeight

    # Only activate sticky on offers index and above certain body height
    if $('body.template--offers-index').length and orgininalContentHeight > asideHeight

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



