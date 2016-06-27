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
    pagination: new Clarat.Search.Cell.Pagination(@mainResults)
    section: $('body').data('section')
    offers_path: location.pathname
    toggle_search_result_details: 'Expand/Collapse'
    globe_img: image_path('ico_globe.svg')

  personalFocusViewObject: =>
    @mainResults = @resultSet.results[0]
    @remoteResults = @resultSet.results[1]

    return specificViewObject =
      personal_focus_with_remote:
        @mainResults.nbHits + @remoteResults.nbHits > 0
      main_results_headline: @mainResultsHeadline('personal_offers')
      remote_results_headline:
        I18n.t 'js.search_results.remote_offers', count: @remoteResults.nbHits

      more_anchor: I18n.t('js.search_results.more')
      more_href: window.location.href # TODO: offers_path(search_form: search_cache.remote_focus)

      faq_text: I18n.t('js.search_results.faq_text')
      faq_anchor: I18n.t('js.search_results.faq_anchor')
      faq_href: "#{I18n.t('js.routes.faq')}#questions_about_our_search"

      has_two_or_more_remote_results: @remoteResults.nbHits > 1
      remote_offers: @remoteResults.hits

  remoteFocusViewObject: =>
    @mainResults = @resultSet.results[0]

    return specificViewObject =
      personal_focus_with_remote: false
      main_results_headline: @mainResultsHeadline('remote_offers')
      remote_focus: true
      toggle_personal_anchor: I18n.t('js.search_results.show_personal') # TODO: permanent? +css


  ## Headline Building Helpers

  mainResultsHeadline: (i18nKey) ->
    output = I18n.t "js.search_results.#{i18nKey}", count: @mainResults.nbHits
    bridge = I18n.t 'js.search_results.bridge'
    enclosing = I18n.t 'js.search_results.enclosing'

    output += " (#{@model.search_location || I18n.t('conf.default_location')}"
    if @model.exact_location == 'true'
      output += " " + HandlebarsTemplates['remove_exact_location']()
    output += ")"

    if @model.category
      output += " in #{@breadcrumbPath @model}"

    if @model.query
      output += " #{bridge}: &bdquo;#{@model.query}&ldquo; "
      output += HandlebarsTemplates['remove_query_link']()

    output + " #{enclosing}"

  # breadcrumps to active category
  breadcrumbPath: (@model) ->
    output = ''
    ancestors = @model.categoryWithAncestors()
    last_index = ancestors.length - 1

    for category, index in ancestors
      output += Handlebars.partials['_category_link'] name: category
      output += ' &rarr; ' unless index is last_index

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
