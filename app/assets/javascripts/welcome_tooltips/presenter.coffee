# Conditionally init and position welcome tooltips, cookie-based
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->

    @cookieLifespanMin  = 120
    @isFrontPage        = $('.template--pages-home').length
    @isOfferIndexPage   = $('.template--offers-index').length
    @world              = if $('body.refugees').length then 'refugees' else 'family'
    @ttAutoTranslations = $('.nav-lang__button')
    @ttWeltRefugees     = $('.tooltip--welt-refugees')
    @ttWeltFamily       = $('.tooltip--welt-family')
    @ttAdvancedSearch   = $('.tooltip--advancedsearch')
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
    @testForAutoTranslateCookie()

  testForAutoTranslateCookie: () =>

    # AutoTranslate warning cookie detect
    if $.cookie 'welcome-tooltips-autotranslation'
      return false
    else
      @initAutomatedTranslationTooltip()
      @setCookieAutoTranslate()


  _highlightTooltip: (elem) =>
    # Get original's most important properties
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

  initAutomatedTranslationTooltip: =>
    that = this

    # Don't init if in German version
    if $('html[lang="de"]').length > 0
      return

    @ttAutoTranslations.qtip
      id: 'ttAutoTranslations'
      position:
        my: "top center"
        at: "bottom center"
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


    @ttAutoTranslations.qtip('api').show()

    return


  setCookieAutoTranslate: =>
    unless $('html[lang="de"]').length

      date = new Date
      date.setTime date.getTime() + @cookieLifespanMin * 60 * 1000

      $.cookie 'welcome-tooltips-autotranslation', 'true',
        expires: date
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
    @ttAutoTranslations.qtip('destroy')
    @ttWeltRefugees.qtip('destroy')
    @ttWeltFamily.qtip('destroy')


$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
