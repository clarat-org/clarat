# using http://vast-engineering.github.io/jquery-popup-overlay/
ready = ->
  overlay = $('#unavailable_location_overlay')
  if overlay.length
    overlay.popup
      autoopen: true

$(document).ready ready
$(document).on 'page:load', ready

