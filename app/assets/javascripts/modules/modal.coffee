# using http://vast-engineering.github.io/jquery-popup-overlay/
ready =  ->
  overlay = $('.js-modal')
  if overlay.length
    overlay.popup()

$(document).ready ready
$(document).on 'page:load', ready
