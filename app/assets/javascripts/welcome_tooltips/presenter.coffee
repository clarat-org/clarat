# Conditionally init and position welcome tooltips, cookie-based
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->

    @cookieLifespan     = 90
    @isFrontPage        = $('.template--pages-home').length
    @isOfferIndexPage   = $('.template--offers-index').length
    @world              = if $('body.refugees').length then 'refugees' else 'family'
    @ttAdvancedSearch   = $('.tooltip--advancedsearch')
    @ttWeltRefugees     = $('.tooltip--welt-refugees')
    @ttWeltFamily       = $('.tooltip--welt-family')
    @overlay            = $('#qtip_welcome_overlay')
    @cloneContainer     = $('#clone-container')
    super()

  CALLBACKS:
    window:
      load: 'init'
      resize: '_hideOverlay'
    document:
      'Clarat.ToggleAdvancedSearch::Toggle': '_hideOverlay'


  init: =>

    if @isFrontPage
      @testForNavWeltCookie()
    else if @isOfferIndexPage
      @testForNavWeltCookie()
      @testForAdvSearchCookie()
    else
      @testForNavWeltCookie()


  testForNavWeltCookie: () =>

    # NavWelt cookie detect
    if $.cookie 'welcome-tooltips-navwelt'
      return false
    else
      @initNavWeltTooltips()
      @setCookieNavWelt()


  testForAdvSearchCookie: () =>

    # Advanced search cookie detect
    if $.cookie 'welcome-tooltips-advsearch'
      return false
    else
      @initAdvSearchTooltips()
      @setCookieAdvSearch()


  _highlightTooltip: (elem) =>
    # Get original most important properties
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


  initNavWeltTooltips: =>
    that = this

    position_my = if @isFrontPage then "top center" else "bottom center"
    position_at = if @isFrontPage then "bottom center" else "top center"

    @ttWeltRefugees.qtip
      id: 'ttWeltRefugees'
      position:
        my: position_my
        at: position_at
        effect: false
        viewport: $('body')
        adjust:
          method: 'invert adjust'
      content:
        button: 'x'
      show:
        event: false
      hide:
        event: false
      events:
        show: ->
          that._showOverlay()
        hide: ->
          that._hideOverlay()
      style:
        tip:
          height: 16
          width: 22
          corner: 'top center'


    @ttWeltFamily.qtip
      id: 'ttWeltFamily'
      position:
        my: position_my
        at: position_at
        effect: false
        viewport: $('body')
        adjust:
          method: 'invert adjust'
      content:
        button: 'x'
      show:
        event: false
      hide:
        event: false
      events:
        show: ->
          that._showOverlay()
        hide: ->
          that._hideOverlay()
      style:
        tip:
          height: 16
          width: 22
          corner: 'top center'


    if @world == "family"
      @ttWeltRefugees.qtip('api').show()
      @_highlightTooltip(@ttWeltRefugees)

    else
      @ttWeltFamily.qtip('api').show()
      @_highlightTooltip(@ttWeltFamily)

    return


  initAdvSearchTooltips: =>
    that = this

    position_my = if $(window).width() < 750 then 'top center' else 'bottom right'
    position_at = if $(window).width() < 750 then 'top center' else 'top right'

    @ttAdvancedSearch.qtip
      id: 'ttAdvancedSearch'
      position:
        my: position_my
        at: position_at
        effect: false
      content:
        button: 'x'
      show:
        event: false
      hide:
        event: false
      events:
        show: ->
          that._showOverlay()
        hide: ->
          that._hideOverlay()
      style:
        tip:
          corner: false
          height: 16
          width: 22
          corner: 'bottom right'

    unless @isFrontPage

      @ttAdvancedSearch.qtip('api').show()
      @_highlightTooltip(@ttAdvancedSearch)

    return


  setCookieNavWelt: =>
    $.cookie 'welcome-tooltips-navwelt', 'true',
      expires: @cookieLifespan
      path: '/'


  setCookieAdvSearch: =>
    $.cookie 'welcome-tooltips-advsearch', 'true',
      expires: @cookieLifespan
      path: '/'


  _showOverlay: =>
    that = this
    $('body').addClass 'overlay-active'
    @overlay.show()
    @cloneContainer.show()
    @cloneContainer.click () ->
      that._hideOverlay()


  _hideOverlay: =>
    @overlay.hide()
    @cloneContainer.hide()
    $('body').removeClass 'overlay-active'
    @ttAdvancedSearch.qtip('destroy')
    @ttWeltRefugees.qtip('destroy')
    @ttWeltFamily.qtip('destroy')


$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
