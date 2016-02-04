#
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->
    @tooltips = $('.tooltip--welcome')
    @world = if $('body.refugees').length then 'refugees' else 'family'
    @overlay = $('#qtip_welcome_overlay')
    super()

  CALLBACKS:
    window:
      load: 'init'

  init: =>

    that = this

    @tooltips.each ->

      text = $(this).data 'tooltip-text'
      advancedsearch = $(this).hasClass "tooltip--advancedsearch"

      my = if advancedsearch then 'bottom right' else 'bottom center'
      corner = if advancedsearch then 'bottom right' else 'bottom center'

      $(this).qtip
        position:
          my: my
          at: 'top center'
          effect: false
          viewport: $(window)
        content:
          text: text
          button: 'x'
        show:
          event: false
        hide:
          event: false
        events:
          show: ->
            that.showOverlay()
          hide: ->
            that.hideOverlay()
        style:
          tip:
            height: 16
            width: 22
            corner: corner

    unless @hasCookie()

      if $('body.template--pages-home').length or $('body.template--offers-index').length
        @tooltips.qtip('api').show()

    return


  setCookie: =>
    $.cookie 'welcome-tooltips', 'true', expires: 90

  hasCookie: =>
    @setCookie()
    return false
#    unless $.cookie 'welcome-tooltips'
#      return false
#
#    else
#      return true

  showOverlay: =>
    that = this
    @overlay.show()
    @overlay.click () ->
      that.hideOverlay()
      that.tooltips.qtip('api').hide()


  hideOverlay: =>
   @overlay.hide()


$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
