# Enhance/customize shariff third party script
Clarat.shariffAdditional = {}
class Clarat.shariffAdditional.Presenter extends ActiveScript.Presenter
  constructor: ->

    @shareLabel = I18n.t('js.shariff.share_label')

    super()

  CALLBACKS:
    window:
      resize: 'init'
    document:
      ready: 'init'

  init: () =>

    @_handleHover()

    if $(window).width() >= 750
      @_removeLabelFromComponent()
      @_addLabelToButtons()
    else
      @_addLabelToComponent()
      @_removeLabelFromButtons()


  _handleHover: () =>

    $('.shariff-button').hover ->
      $('.shariff-button').removeClass "shariff-button--expanded"
      $(this).addClass "shariff-button--expanded"
    , ->
      $('.shariff-button').addClass "shariff-button--expanded"


  _addLabelToComponent: () =>

    unless $('.shariff__label').length
      $('.shariff > ul').prepend '<li class="shariff__label">' + @shareLabel + ':</li>'


  _removeLabelFromComponent: () =>

    if $('.shariff__label').length
      $('.shariff__label').remove()

  _addLabelToButtons: () =>
    $('.shariff .shariff-button .share_text').text( @shareLabel )

  _removeLabelFromButtons: () =>
    $('.shariff .shariff-button .share_text').text('')

$(document).ready ->
  new Clarat.shariffAdditional.Presenter
