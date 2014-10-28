# using http://vast-engineering.github.io/jquery-popup-overlay/
$(document).ready ->
  overlay = $('#unavailable_location_overlay')
  if overlay.length
    $('#unavailable_location_overlay').popup
      autoopen: true
