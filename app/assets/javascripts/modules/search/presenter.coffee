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
    @render '#search-wrapper', 'search', new Clarat.Search.SearchCell(@model)

  # Rendered upon successful sendSearch.
  searchResults: (resultSet) =>
    searchResultsObject = new Clarat.Search.SearchResultsCell resultSet, @model

    @render '.Listing-results', 'search_results', searchResultsObject
    markers = new Clarat.Search.MapMarkersCell searchResultsObject.main_offers
    if Clarat.GMaps.loaded
      Clarat.GMaps.Map.initialize(markers)
    else
      $('#search-wrapper').append(
        $("<div id='map-data' data-markers='#{JSON.stringify markers}'>")
      )


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
    @model.updateAttributes category: $(event.target).data('name')
    # TODO: Move elsewhere
    $('.Categories__list').find('.active').removeClass('active')
    $(event.target).parents('li').addClass 'active'
    # /Move
    @sendSearch()
    @stopEvent event

  handleMoreClick: (event) =>
    @model.updateAttributes contact_type: 'remote'
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
