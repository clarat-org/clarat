# Toggle advanced search form
# via button click in header
Clarat.ToggleAdvancedSearch = {}
class Clarat.ToggleAdvancedSearch.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '#main-search__advanced-filter':
      click: 'handleClick'

  handleClick: (event) =>
    event.preventDefault()

    form = $('.filter-form')
    trigger = $('#main-search__advanced-filter')
    visibleClass = 'is-visible'
    formMoreLabel = I18n.t('js.search.form_more_label')
    formLessLabel = I18n.t('js.search.form_less_label')

    if form.hasClass visibleClass
      form.removeClass visibleClass
      trigger.text formMoreLabel
    else
      form.addClass visibleClass
      trigger.text formLessLabel

$(document).on 'ready', ->
  new Clarat.ToggleAdvancedSearch.Presenter
