initStickySidebar = ->
  $sticky = $(".template--offers-index").find(".aside-standard")
  stickyWidth = $sticky.width()

  if $(document).width() >= 900
    if !!$sticky.offset()
      stickyTop = $sticky.offset().top

      $(window).scroll ->
        footerInViewport = withinViewport $(".footer-main")
        windowTop = $(window).scrollTop()

        if stickyTop < windowTop
          top = if footerInViewport then -140 else 0
          $sticky.css
            position: 'fixed'
            top: top
            width: stickyWidth
        else
          $sticky.
            css('position', 'static').
            css('width', '35.7%'). # chaining, because otherwise false top value
            css('top', 'auto')

  else
    $(window).scroll ->
      $sticky.
        css('position', 'static').
        css('width', '100%'). # chaining, because otherwise false top value
        css('top', 'auto')

$(window).resize initStickySidebar
$(document).ready initStickySidebar
