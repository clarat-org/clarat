Clarat.StickyMobileNav = {}
class Clarat.StickyMobileNav.Presenter extends ActiveScript.Presenter
  constructor: ->
    @bannerAndNavHeight =
      $('.Banner').outerHeight() + $('.nav-welt--notstart').outerHeight()
    @formDistributor = $('.Distributor__search-form')
    @navDistributor = $('.Distributor--navigation')
    super()

  CALLBACKS:
    window:
      resize: 'handleNewScreenWidth'
      load: 'handleNewScreenWidth'
      scroll: 'handleScrolled'

  handleNewScreenWidth: =>
    @isSmartphone = ($(window).width() < 501)

  handleScrolled: =>
    return unless @isSmartphone

    if $(window).scrollTop() > @bannerAndNavHeight
      @formDistributor.addClass 'is-fixed'
      # prevent pixel jump:
      @navDistributor.css 'margin-bottom', "#{@bannerAndNavHeight}px"
    else
      @formDistributor.removeClass 'is-fixed'
      @navDistributor.css 'margin-bottom', '0'


$(document).ready ->
  return if $("body.template--pages-home").length
  new Clarat.StickyMobileNav.Presenter
