flashHandler = ->
  $('body').on 'click', '.Flash-message__close', (e) ->
    e.target.parentElement.remove()

$(document).ready flashHandler
$(document).on 'page:load', flashHandler
