Clarat.ToggleFieldsets = {}
class Clarat.ToggleFieldsets.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '.filter-form__fieldset__headline':
      click: 'handleClick'

  handleClick: () =>

$(document).on 'ready', ->
  new Clarat.ToggleFieldsets.Presenter
