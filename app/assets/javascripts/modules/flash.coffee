Clarat.Flash =
  initializeCloseClickHandler: ->
    $('body').on 'click', '.Flash-message__close', (e) ->
      e.target.parentElement.remove()

  createFlash: (type, message)->
    $('#Flash-messages').append(
      HandlebarsTemplates['flash_message'].render
        type: type
        message: message
    )
$(document).ready Clarat.Flash.initializeCloseClickHandler
$(document).on 'page:load', Clarat.Flash.initializeCloseClickHandler
