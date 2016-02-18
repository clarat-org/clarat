#
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->
    @tooltips = $('.tooltip--welcome')
    @ttAdvancedSearch = $('.tooltip--advancedsearch')
    @ttFrontWeltRefugees = $('.tooltip--welt-refugees')
    @ttFrontWeltFamily = $('.tooltip--welt-family')
    @world = if $('body.refugees').length then 'refugees' else 'family'
    @overlay = $('#qtip_welcome_overlay')
    @cloneContainer = $('#clone-container')
    super()

  CALLBACKS:
    window:
      load: 'init'
      resize: 'hideOverlay'

  init: =>
    @initFrontTooltips()
    @initOfferIndexTooltip()


  initOfferIndexTooltip: =>
    that = this

    @ttAdvancedSearch.qtip
      position:
        my: 'bottom right'
        at: 'top center'
        effect: false
      content:
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
          corner: 'bottom right'

    unless @hasCookie()

      if $('body.template--offers-index').length
        @ttAdvancedSearch.qtip('api').show()
        @highlightTooltip(@ttAdvancedSearch)

    return


  highlightTooltip: (elem) =>

    # Get original most imporant properties
    left = elem.offset().left
    top = elem.offset().top
    height = elem.css "height"

    clone = elem.clone()

    # Assign them to clone
    clone.css
      "position": "absolute"
      "left"    : left
      "top"     : top
      "max-height" : height

    # Put in overlay
    clone.prependTo @cloneContainer;


  initFrontTooltips: =>
    that = this

    @ttFrontWeltRefugees.qtip
      position:
        my: 'bottom center'
        at: 'top left'
        effect: false
        viewport: $(window)
        adjust:
          method: 'none none'
      content:
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
          corner: 'bottom right'


      @ttFrontWeltFamily.qtip
        position:
          my: 'bottom center'
          at: 'top right'
          effect: false
          viewport: $(window)
          adjust:
            method: 'none none'
        content:
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
            corner: 'bottom left'

    unless @hasCookie()

      if $('body.family.template--pages-home').length

        @ttFrontWeltRefugees.qtip('api').show()
        @highlightTooltip(@ttFrontWeltRefugees)


      else if $('body.refugees.template--pages-home').length

        @ttFrontWeltFamily.qtip('api').show()
        @highlightTooltip(@ttFrontWeltFamily)


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
    $('body').addClass 'overlay-active'
    @overlay.show()
    @cloneContainer.show()
    @overlay.click () ->
      that.hideOverlay()


  hideOverlay: =>
    @overlay.hide()
    @cloneContainer.hide()
    $('body').removeClass 'overlay-active'
    @ttAdvancedSearch.qtip('destroy')
    @ttFrontWeltRefugees.qtip('destroy')
    @ttFrontWeltFamily.qtip('destroy')


$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
