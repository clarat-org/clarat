# Frontend Search Implementation - ViewModel for Search#show
# Handles almost all logic for the view.
# Is not based on the Search model, but the resultSet that the Presenter queries
# from the remote index.
# Patterns: Model-Template-Presenter structure
class Clarat.Search.Cell.SearchResults
  constructor: (@resultSet, @model) ->
    viewObjectFocus = if @model.isPersonal()
                        @personalFocusViewObject
                      else
                        @remoteFocusViewObject

    return _.merge viewObjectFocus(), @generalViewObject()

  generalViewObject: =>

    show_on_big_map_anchor: I18n.t('js.search_results.map.show_on_big_map')

    main_offers: @mainResults.hits
    main_count: @mainResults.nbHits
    pagination: new Clarat.Search.Cell.Pagination(@mainResults)

  personalFocusViewObject: =>
    @mainResults = @resultSet.results[0]
    @remoteResults = @resultSet.results[1]
    @nearbyResults = @resultSet.results[2]

    return specificViewObject =
      personal_focus_with_remote: true
      main_results_headline: @mainResultsHeadline('personal_offers')
      remote_results_headline:
        I18n.t 'js.search_results.remote_offers', count: @remoteResults.nbHits

      more_anchor: I18n.t('js.search_results.more')
      more_href: window.location.href # TODO: offers_path(search_form: search_cache.remote_focus)

      has_two_or_more_remote_results: @remoteResults.nbHits > 1
      remote_offers: @remoteResults.hits

  remoteFocusViewObject: =>
    @mainResults = @resultSet.results[0]
    @nearbyResults = @resultSet.results[1]

    return specificViewObject =
      personal_focus_with_remote: false
      main_results_headline: @mainResultsHeadline('remote_offers')
      remote_focus_and_has_personal_results: @nearbyResults.nbHits > 1 # works?
      toggle_personal_anchor: "(Zeige lokale Angebote)" # TODO: permanent? +css


  ## Headline Building Helpers

  mainResultsHeadline: (i18nKey) ->
    output = I18n.t "js.search_results.#{i18nKey}", count: @mainResults.nbHits

    if @model.category
      output += " in #{@breadcrumbPath @model}"

    if @model.query
      output += ": &bdquo;#{@model.query}&ldquo; "

      if @model.category
        output += HandlebarsTemplates['remove_query_link']()

    output + " (#{@model.search_location})"

  # breadcrumps to active category
  breadcrumbPath: (@model) ->
    output = ''
    ancestors = @model.categoryWithAncestors()
    last_index = ancestors.length - 1

    for category, index in ancestors
      output += Handlebars.partials['_category_link'] name: category
      output += ' > ' unless index is last_index

    output
