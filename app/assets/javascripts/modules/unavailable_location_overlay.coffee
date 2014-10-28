$(document).ready ->
  overlay = $('#unavailable_location_overlay')
  if overlay.length
    $('#unavailable_location_overlay').popup
      autoopen: true
