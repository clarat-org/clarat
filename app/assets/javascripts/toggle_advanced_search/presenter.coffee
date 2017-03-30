# Toggle advanced search form
# via button click in header
Clarat.ToggleAdvancedSearch = {}
class Clarat.ToggleAdvancedSearch.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '.off-canvas-container__trigger':
      click: 'handleClick'
    '.main-search__advanced-filter':
      click: 'handleClick'
    document:
      'Clarat.Search::FirstSearchRendered': 'handleSearchRendered'

  handleClick: (event) =>
    event.preventDefault()
    @_toggleState(event)
    $(document).trigger 'Clarat.ToggleAdvancedSearch::Toggle'

  # show advanced search if a filter was used
  handleSearchRendered: =>
    return unless @_isSearchFiltered()
    @_toggleState()

  ### Private Methods (ue) ###

  _toggleState: (event = {}) ->
    form = $('.filter-form')
    target = $(event.target).data 'target'

    if target
      # We're on mobile/off canvas
      $(target).trigger 'click'
    else
      # We're on desktop
      filterForm = $('.filter-form')
      filterForm.toggleClass 'is-visible'
      filterForm.attr 'aria-hidden', (i, attr) ->
        if attr == 'true' then 'false' else 'true'

      if form.hasClass 'is-visible'
        $('.main-search__advanced-filter').text I18n.t('js.search.form_less_label')
      else
        $('.main-search__advanced-filter').text I18n.t('js.search.form_more_label')

      $(event.target).attr 'aria-expanded', (i, attr) ->
        if attr == 'true' then 'false' else 'true'


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
