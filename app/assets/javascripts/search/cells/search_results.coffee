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
    @generateMainResultStamps()
    main_offers: @mainResults.hits
    main_count: @mainResults.nbHits
    pagination: new Clarat.Search.Cell.Pagination(@mainResults)
    section: $('body').data('section')

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
      faq_href: "/#{@model.section}/haeufige-fragen/#search_section"

      has_two_or_more_remote_results: @remoteResults.nbHits > 1
      remote_offers: @remoteResults.hits

  remoteFocusViewObject: =>
    @mainResults = @resultSet.results[0]

    return specificViewObject =
      personal_focus_with_remote: false
      main_results_headline: @mainResultsHeadline('remote_offers')
      remote_focus: true
      toggle_personal_anchor: 'Zeige Angebote vor Ort' # TODO: permanent? +css


  ## Headline Building Helpers

  mainResultsHeadline: (i18nKey) ->
    output = I18n.t "js.search_results.#{i18nKey}", count: @mainResults.nbHits
    bridge = I18n.t 'js.search_results.bridge'
    enclosing = I18n.t 'js.search_results.enclosing'

    if @model.category
      output += " in #{@breadcrumbPath @model}"

    if @model.query
      output += " #{bridge}: &bdquo;#{@model.query}&ldquo; "
      output += HandlebarsTemplates['remove_query_link']()

    output + " (#{@model.search_location}) #{enclosing}"

  # breadcrumps to active category
  breadcrumbPath: (@model) ->
    output = ''
    ancestors = @model.categoryWithAncestors()
    last_index = ancestors.length - 1

    for category, index in ancestors
      output += Handlebars.partials['_category_link'] name: category
      output += ' &rarr; ' unless index is last_index

    output

  generateMainResultStamps: =>
    console.log @mainResults.hits[0]
    for main_result, index in @mainResults.hits
      main_result.stamp = @generateStampForOffer(main_result)
    for remote_result, index in @remoteResults.hits
      remote_result.stamp = @generateStampForOffer(main_result)

  generateStampForOffer: (offer) ->
    return 'no TA!' if offer._target_audience_filters.empty?
    ta = offer._target_audience_filters[0]
    locale_entry = 'js.search_results.target_audience' + ".#{ta}"
    stamp = I18n.t('js.search_results.target_audience.prefix')
    append_age = true
    child_age = false
    if ta == 'children'
      if offer.gender_first_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}"
      else if offer.age_from >= 14 && offer.age_to >= 14
        locale_entry += '.adolescents'
      else if offer.age_from < 14 && offer.age_to >= 14
        locale_entry += '.plus_adolescents'
      else
        locale_entry += '.default'
    else if ta == 'parents'
      if offer.gender_first_part_of_stamp != null && offer.gender_second_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
      else if offer.gender_first_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.default"
        child_age = true
      else
        locale_entry += '.default'
        child_age = true
    else if ta == 'nuclear_family'
      if offer.gender_first_part_of_stamp != null && offer.gender_second_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
      else if offer.gender_first_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.default"
      else if offer.gender_second_part_of_stamp != null
        locale_entry += ".special_#{offer.gender_second_part_of_stamp}"
      else
        locale_entry += '.default'
        append_age = false
    else if ta == 'everyone'
      append_age = false
    console.log locale_entry
    stamp += I18n.t(locale_entry)
    stamp += @generateAgeForStamp(offer.age_from, offer.age_to, offer.age_visible && append_age, child_age)

  generateAgeForStamp: (from, to, visible, child_age) ->
    return '' if !visible
    age_string = if child_age then "#{I18n.t('js.search_results.stamp_age.of_child')} " else ''
    if from == 0
      age_string += "#{I18n.t('js.search_results.stamp_age.to')} #{to}"
    else if to == 0
      age_string += "#{I18n.t('js.search_results.stamp_age.from')} #{from}"
    else if from == to
      age_string += "#{from}"
    else
      age_string += "#{from} - #{to}"
    " (#{age_string} #{I18n.t('js.search_results.stamp_age.suffix')})"
