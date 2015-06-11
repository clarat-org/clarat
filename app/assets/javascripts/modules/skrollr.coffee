$(document).ready ->
  unless Clarat.isMobile()
    skrollr.init
      forceHeight: false
