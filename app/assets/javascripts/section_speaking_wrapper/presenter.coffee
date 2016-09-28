# If offer spoken language count is higher that threshold, collapse the rest
Clarat.SectionSpeakingWrapper = {}
class Clarat.SectionSpeakingWrapper.Presenter extends ActiveScript.Presenter
  constructor: ->
    super()
    @trigger = $('.section-content__toggle')
    @content = $('.section-content__wrapper')
    @handleToggleClicked() # once initially to hide large list

  THRESHOLD: 5

  CALLBACKS:
    window:
      load: '_setupTriggerIfNeeded'
      resize: '_setupTriggerIfNeeded'
    document:
      'Clarat.SectionSpeakingWrapper::ToggleClicked': 'handleToggleClicked'

  # simple class & text toggle
  handleToggleClicked: =>
    if @content.hasClass 'is-expanded'
      @content.removeClass 'is-expanded'
      @trigger.html "<span>" + I18n.t('js.lang_list_toggle.more') + "</span>"
    else
      @content.addClass 'is-expanded'
      @trigger.html "<span>" + I18n.t('js.lang_list_toggle.less') + "</span>"


  ### PRIVATE ###

  # See if list of languages is larger than threshold, if yes set up trigger
  _setupTriggerIfNeeded: =>
    item = $('.section-content--speaking li')
    if item.length > (@THRESHOLD + 1)
      # resize window
      $('.section-content__wrapper').height(item.innerHeight() * @THRESHOLD)

      # register callback
      @trigger.show().unbind('click').bind 'click', ->
        $(document).trigger('Clarat.SectionSpeakingWrapper::ToggleClicked')

$(document).ready ->
  new Clarat.SectionSpeakingWrapper.Presenter
