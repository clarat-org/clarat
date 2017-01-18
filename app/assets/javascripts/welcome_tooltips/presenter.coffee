# Conditionally init and position welcome tooltips, cookie-based
Clarat.welcomeTooltips = {}
class Clarat.welcomeTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->

    @isFrontPage        = $('.template--pages-home').length
    @isOfferIndexPage   = $('.template--offers-index').length
    @ttAutoTranslations = $('.nav-lang__button')
    @overlay            = $('#qtip_welcome_overlay')

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

      $.cookie 'welcome-tooltips-autotranslation', 'true',
        expires: 2/24
        path: '/'


  _showOverlay: =>
    that = this
    $('body').addClass 'overlay-active'
    @overlay.show()
    @overlay.click () ->
      that._hideOverlay()


  _hideOverlay: =>
    @overlay.hide()
    $('body').removeClass 'overlay-active'
    @ttAutoTranslations.qtip('destroy')


$(document).ready ->
  new Clarat.welcomeTooltips.Presenter
