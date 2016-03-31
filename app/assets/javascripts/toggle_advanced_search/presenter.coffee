# Toggle advanced search form
# via button click in header
Clarat.ToggleAdvancedSearch = {}
class Clarat.ToggleAdvancedSearch.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '.main-search__advanced-filter':
      click: 'handleClick'
    document:
      'Clarat.Search::FirstSearchRendered': 'handleSearchRendered'

  handleClick: (event) =>
    event.preventDefault()
    @_toggleState()
    $(document).trigger 'Clarat.ToggleAdvancedSearch::Toggle'

  # show advanced search if a filter was used
  handleSearchRendered: =>
    return unless @_isSearchFiltered()
    @_toggleState()

  ### Private Methods (ue) ###

  _toggleState: ->
    form = $('.filter-form')
    trigger = $('.main-search__advanced-filter')
    visibleClass = 'is-visible'
    formMoreLabel = I18n.t('js.search.form_more_label')
    formLessLabel = I18n.t('js.search.form_less_label')

    if form.hasClass visibleClass
      form.removeClass visibleClass
      trigger.text formMoreLabel
    else
      form.addClass visibleClass
      trigger.text formLessLabel

  _isSearchFiltered: ->
    formParams = $.query.keys.search_form
    return false unless formParams
    return typeof formParams.age is 'number' or
      typeof formParams.language is 'string' or
      typeof formParams.target_audience is 'string' or
      typeof formParams.exclusive_gender is 'string' or
      (typeof formParams.encounters is 'string' and
      formParams.encounters.split(',').length < 5)


$(document).ready ->
  new Clarat.ToggleAdvancedSearch.Presenter
