# Init qtips in trait_filter listings
Clarat.OfferShowTooltips = {}
class Clarat.OfferShowTooltips.Presenter extends ActiveScript.Presenter
  constructor: ->
    super()
    @itemsWithExplanation = $('.section-content--more-info').find('li[title]')

  CALLBACKS:
    window:
      load: 'initTooltips'

  initTooltips: =>
    @itemsWithExplanation.qtip()

$(document).ready ->
  new Clarat.OfferShowTooltips.Presenter
