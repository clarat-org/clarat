#
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->
    @tooltips = $('.tooltip--welcome')
    @ttAdvancedSearch = $('.tooltip--advancedsearch')
    @ttWeltRefugees = $(' .tooltip--welt-refugees')
    @ttWeltFamily = $(' .tooltip--welt-family')
    @world = if $('body.refugees').length then 'refugees' else 'family'
    @overlay = $('#qtip_welcome_overlay')
    @cloneContainer = $('#clone-container')
    super()

  CALLBACKS:
    window:
      load: 'init'
      resize: 'hideOverlay'
    document:
      'Clarat.ToggleAdvancedSearch::Toggle': 'hideOverlay'

  init: =>

    if $('body.template--pages-home').length
      @initFrontTooltips()
    else
      @initNotFrontTooltips()


  initNotFrontTooltips: =>
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

    @ttWeltRefugees.qtip
      position:
        my: 'top right'
        at: 'bottom right'
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
          corner: 'top center'

    @ttWeltFamily.qtip
      position:
        my: 'top right'
        at: 'bottom right'
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
          corner: 'top center'

    unless @hasCookie()

     unless $('body.template--pages-home').length
        @ttAdvancedSearch.qtip('api').show()

        if @world == "refugees"
          @ttWeltFamily.qtip('api').show()
          @_highlightTooltip(@ttWeltFamily)
        else
          @ttWeltRefugees.qtip('api').show()
          @_highlightTooltip(@ttWeltRefugees)

        @_highlightTooltip(@ttAdvancedSearch)


    return


  _highlightTooltip: (elem) =>

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

    @ttWeltRefugees.qtip
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


      @ttWeltFamily.qtip
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

      if @world == "family"
        @ttWeltRefugees.qtip('api').show()
        @_highlightTooltip(@ttWeltRefugees)

      else
        @ttWeltFamily.qtip('api').show()
        @_highlightTooltip(@ttWeltFamily)

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
    @cloneContainer.click () ->
      that.hideOverlay()


  hideOverlay: =>
    @overlay.hide()
    @cloneContainer.hide()
    $('body').removeClass 'overlay-active'
    @ttAdvancedSearch.qtip('destroy')
    @ttWeltRefugees.qtip('destroy')
    @ttWeltFamily.qtip('destroy')


$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
