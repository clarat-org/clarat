# Frontend Search Implementation - Presenter
# The presenter handles communication between the view and the model.
# It's like a rails Controller, but also handles requests from the view (JS
# callbacks)
# Patterns: Singleton instance; Model-Template-Presenter structure
class Clarat.Search.Presenter extends ActiveScript.Presenter
  # This SubApplication sits inside the RoR Offers#index
  constructor: ->
    super()

    @model = Clarat.Search.Model.load()
    @search()


  ### "CREATE ACTION" ###

  ###
  Sending a search means that we compile the available parameters into
  a search query and instead of sending (saving) it to our database, we send
  it to a remote search index, which returns aus the completed search objects
  for the searchResults view. That means #searchResults can't be called directly
  without #sendSearch as it's not persisted.
  ###
  sendSearch: =>
    @model.getSearchResults().then(@searchResults).catch(@failure)


  ### "SHOW ACTIONS" ###

  # Renders a mostly empty wireframe that the search results will be placed in.
  search: ->
    @render '#search-wrapper', 'search', new Clarat.Search.Cell.Search(@model)

  # Rendered upon successful sendSearch.
  searchResults: (resultSet) =>
    viewModel = new Clarat.Search.Cell.SearchResults resultSet, @model

    @render '.Listing-results', 'search_results', viewModel
    if @model.isPersonal()
      Clarat.Search.Concept.BuildMap.run viewModel.main_offers
    Clarat.Search.Concept.UpdateCategories.updateCounts resultSet.results.pop()


  ### CALLBACKS ###

  CALLBACKS:
    '#search_form_query':
      keyup: 'handleQueryChange'
    '.JS-CategoryLink':
      click: 'handleCategoryClick'
    '.JS-MoreLink':
      click: 'handleMoreClick'
    '.JS-PaginationLink':
      click: 'handlePaginationClick'

  handleQueryChange: (event) =>
    @model.assignAttributes query: event.target.value
    @sendSearch()

  handleCategoryClick: (event) =>
    categoryName = $(event.target).data('name')
    @model.updateAttributes category: categoryName
    Clarat.Search.Concept.UpdateCategories.updateActiveClasses categoryName
    @sendSearch()
    @stopEvent event

  handleMoreClick: (event) =>
    @model.updateAttributes contact_type: 'remote'
    $('.aside-standard').toggle()
    @sendSearch()
    @stopEvent event

  handlePaginationClick: (event) =>
    @model.updateAttributes page: ($(event.target).data('page') - 1)
    @sendSearch()
    @stopEvent event

  # Error view, rendered in case of any sendSearch/searchResults exceptions.
  failure: (error) =>
    console.log error
    @render '#search-wrapper', 'error_ajax', I18n.t('js.ajax_error')


  ### OTHER PRIVATE METHODS (ue) ###

  stopEvent: (event) ->
    event.preventDefault()
    false
