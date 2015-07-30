# Single Click Button - Presenter
# A button that should only allow a single click and is disabled afterwards
Clarat.SingleClickButton = {}
class Clarat.SingleClickButton.Presenter extends ActiveScript.Presenter
  constructor: ->
    super()
    @buttonStates = {}

  ### CALLBACKS ###

  CALLBACKS:
    '.JS-Single-Click-Button':
      click: 'handleClick'
      finished: 'handleFinished' # custom event

  handleClick: (event) =>
    $target = $(event.target)
    if not $target.hasClass('JS-Single-Click-Button') or
       @buttonStates[event.target.className] is 'clicked'

      return @stopEvent event
    else

      $target.addClass 'JS-Single-Click-Button__active'
      @buttonStates[event.target.className] = 'clicked'

      @render event.target, 'single_click_button_active',
        originalHTML: $target.html()

  handleFinished: (event) =>
    if @buttonStates[event.target.className] is 'clicked'
      @render event.target, 'single_click_button_finished',
        originalHTML:
          $(event.target).find('.JS-Single-Click-Button__original').html()

Clarat.SingleClickButton.Presenter.get()
