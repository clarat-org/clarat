# JS helper for equal height situations that can't be helped with flexbox

Clarat.equalHeightHelper = {}

class Clarat.equalHeightHelper.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    document:
      ready: 'init'

  init: =>
    # Use helper for equal height CTA on front page
    if $('body.template--pages-section_choice').length and $(window).width() >= 750
      @_setEqualHeights($('.section-choice__cta'))

  _setEqualHeights: ($el) =>

    greatestHeight = 0
    $el.each ->
      theHeight = $(this).height()

      if theHeight > greatestHeight
        greatestHeight = theHeight

      return
    $el.height greatestHeight

$(document).ready ->
  new Clarat.equalHeightHelper.Presenter