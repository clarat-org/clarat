Clarat.Flash =
  initializeCloseClickHandler: ->
    $('body').on 'click', '.Flash-message__close', (e) ->
      e.target.parentElement.remove()

  createFlash: (type, message)->
    HandlebarsTemplates['flash_message']( { type: type, message: message })
$(document).ready Clarat.Flash.initializeCloseClickHandler
$(document).on 'page:load', Clarat.Flash.initializeCloseClickHandler
