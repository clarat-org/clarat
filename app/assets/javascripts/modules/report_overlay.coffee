# using http://vast-engineering.github.io/jquery-popup-overlay/
$(document).ready ->
  overlay = $('#js-report-overlay')
  if overlay.length
    overlay.popup()
