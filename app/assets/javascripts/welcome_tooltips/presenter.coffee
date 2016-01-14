#
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->
    @tooltips = $('.tooltip--welcome')
    super()

  CALLBACKS:
    window:
      load: 'init'

  init: =>

    @tooltips.each ->
      text = $(this).data 'tooltip-text'

      $(this).qtip
        position:
          my: 'bottom left'
          at: 'top left'
          effect: false
          viewport: $(window)
        content:
          text: text
          button: 'x'
        hide:
          event: false

    unless @hasCookie()
      @tooltips.qtip('api').show()

    return


  hasCookie: =>

    unless $.cookie 'welcome-tooltips'
      $.cookie 'welcome-tooltips', 'true', expires: 90
      return false

    else
      return true

$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
