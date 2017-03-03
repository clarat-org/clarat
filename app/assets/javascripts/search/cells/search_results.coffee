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
    @addValuesToSearchResults()
    main_offers: @mainResults.hits
    main_count: @mainResults.nbHits
    main_results_query: @mainResultsQuery()
    pagination: new Clarat.Search.Cell.Pagination(@mainResults)
    section: $('body').data('section')
    offers_path: location.pathname
    toggle_search_result_details: 'Expand/Collapse'
    algolia_logo_path: image_path('banner--powered-by-algolia.svg')
    headline_sort_order: I18n.t('js.search.headlines.sort')
    sort_order: @model.getSortOrders()
    personal: @model.isPersonal()

    personal_anchor: I18n.t(
      'js.search_results.personal_anchor', count: @resultSet.results[0].nbHits
    )
    remote_anchor: I18n.t(
      'js.search_results.remote_anchor', count: @resultSet.results[1].nbHits
    )
    switch_href: window.location.href # TODO: offers_path(search_form: search_cache.remote_focus)
    personalActiveClass:
      if @model.contact_type is 'personal' then 'Type-results__item--active' else ''
    remoteActiveClass:
      if @model.contact_type is 'remote' then 'Type-results__item--active' else ''

  personalFocusViewObject: =>
    @mainResults = @resultSet.results[0]
    @remoteResults = @resultSet.results[1]

    return specificViewObject =
      personal_focus_with_remote:
        @mainResults.nbHits + @remoteResults.nbHits > 0
      main_results_headline: @mainResultsHeadline('personal_offers')
      main_results_location: @mainResultsLocation()
      remote_results_headline:
        I18n.t 'js.search_results.remote_offers', count: @remoteResults.nbHits

      faq_text: I18n.t('js.search_results.faq_text')
      faq_anchor: I18n.t('js.search_results.faq_anchor')
      faq_href: "#{I18n.t('js.routes.faq')}#questions_about_our_search"

      has_two_or_more_remote_results: @remoteResults.nbHits > 1
      remote_offers: @remoteResults.hits

  remoteFocusViewObject: =>
    @mainResults = @resultSet.results[1]

    return specificViewObject =
      personal_focus_with_remote: false
      main_results_headline: @mainResultsHeadline('remote_offers')
      remote_focus: true
      toggle_personal_anchor: I18n.t('js.search_results.show_personal') # TODO: permanent? +css


  mainResultsHeadline: (i18nKey) ->
    if @model.category
      "#{@breadcrumbPath @model}"

  mainResultsQuery: () ->
    if @model.query
      HandlebarsTemplates['remove_query_link'](query: @model.query)

  mainResultsLocation: () ->
    output = "#{@model.search_location || I18n.t('conf.default_location')}"
    if @model.exact_location == 'true'
      output += HandlebarsTemplates['remove_exact_location']()

    output

  # breadcrumps to active category
  breadcrumbPath: (@model) ->
    output = ''
    ancestors = @model.categoryWithAncestors()
    last_index = ancestors.length - 1

    for category, index in ancestors
      output += Handlebars.partials['_category_link'] name: category
      output += '&nbsp;›&nbsp;' unless index is last_index

    output

  # Add additional values to search results (for hamlbars)
  addValuesToSearchResults: =>
    stamp_variable_name = 'stamp_' + $('body').data('section')
    for item in (@mainResults.hits)
      item.organization_display_name =
          if item.organization_count == 1 then item.organization_names else I18n.t("js.search_results.map.cooperation")
      item.current_stamp = item[stamp_variable_name]
      item.language_explanation = @generateLanguageExplanation(item._language_filters)

    if @remoteResults
      for item in (@remoteResults.hits)
        item.organization_display_name =
            if item.organization_count == 1 then item.organization_names else I18n.t("js.search_results.map.cooperation")
        item.current_stamp = item[stamp_variable_name]
        item.language_explanation = @generateLanguageExplanation(item._language_filters)

  generateLanguageExplanation: (language_filters) ->
    # dont show explanation when german is the only language
    return if language_filters.length == 1 && language_filters[0] == 'deu'
    languages = ''
    for filter, index in language_filters
      languages += I18n.t('js.shared.current_and_original_locale.' + filter).split(' - ')[0]
      if index < language_filters.length - 2
        languages += ', '
      else if index < language_filters.length - 1
        languages += ' ' + I18n.t('js.search_results.language_explanation.connector') + ' '
    I18n.t('js.search_results.language_explanation.text', language_list: languages)
