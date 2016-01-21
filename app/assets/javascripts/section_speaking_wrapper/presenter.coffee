# If offer spoken language count is higher that threshold, collapse the rest
Clarat.SectionSpeakingWrapper = {}
class Clarat.SectionSpeakingWrapper.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      resize: 'init'
      load: 'init'

  wrapper = $('.section-content__wrapper')
  item = $('.section-content--speaking li')
  trigger = $('.section-content__toggle')
  labelMoreLang = trigger.data('expanded-label')
  labelLessLang = trigger.data('collapsed-label')
  count = item.length
  threshold = 5
  content = $('.section-content__wrapper')
  collapsedMaxHeight = item.innerHeight() * threshold

  # Collapse spoken languages list if necessary
  init: ()  =>

    if count > (threshold + 1)
      wrapper.height collapsedMaxHeight

      trigger.text labelLessLang

      trigger.show()
             .unbind 'click'
             .bind 'click', this.toggleHandler

  # Handle trigger interaction
  toggleHandler: () =>

    content.toggleClass 'is-expanded'

    if content.hasClass 'is-expanded'
      trigger.text labelMoreLang
    else
      trigger.text labelLessLang


$(document).ready ->
  new Clarat.SectionSpeakingWrapper.Presenter
