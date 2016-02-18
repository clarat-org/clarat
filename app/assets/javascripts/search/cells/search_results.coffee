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

  personalFocusViewObject: =>
    @mainResults = @resultSet.results[0]
    @remoteResults = @resultSet.results[1]
    # @addValuesToSearchResults(@mainResults.hits)
    # @addValuesToSearchResults(@remoteResults.hits)

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
      faq_href: "#{I18n.t('js.routes.faq')}#who_finds_help"

      has_two_or_more_remote_results: @remoteResults.nbHits > 1
      remote_offers: @remoteResults.hits

  remoteFocusViewObject: =>
    @mainResults = @resultSet.results[0]
    # @addValuesToSearchResults(@mainResults.hits)

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

    output += " (#{@model.search_location}"
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
    current_section = $('body').data('section')
    for item in (@mainResults.hits)
      item.stamp = @generateStampForOffer(item, current_section)
      item.organization_display_name =
          if item.organization_count == 1 then item.organization_names else I18n.t("js.search_results.map.cooperation")

    for item in (@remoteResults.hits)
      item.stamp = @generateStampForOffer(item, current_section)

  generateStampForOffer: (offer, current_section) ->
    # filter target_audience array to only include those of the current_section
    target_audience_for_section = offer._target_audience_filters.filter (id) -> id.slice(0, current_section.length) == current_section
    # (.......) 
    if !target_audience_for_section[0] && current_section == 'refugees'
      target_audience_for_section[0] = 'refugees_general'
    # return with error if there is none => wrong target_audience_filters set
    return 'missing correct target_audience!!' if !target_audience_for_section[0]
    # generate frontend stamp
    @generateOfferStamp(offer, target_audience_for_section[0])



  generateOfferStamp: (offer, ta, current_section) ->
    locale_entry = 'js.search_results.stamp.target_audience' + ".#{ta}"
    stamp = I18n.t('js.search_results.stamp.target_audience.prefix')
    append_age = true
    child_age = false
    if ta == 'family_children'
      if offer.gender_first_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}"
      else if offer.age_from >= 14 && offer.age_to >= 14
        locale_entry += '.adolescents'
      else if offer.age_from < 14 && offer.age_to >= 14
        locale_entry += 'and_adolescents'
      else
        locale_entry += '.default'
    else if ta == 'family_parents'
      if offer.gender_first_part_of_stamp != null && offer.gender_second_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
      else if offer.gender_first_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.default"
        child_age = true
      else
        locale_entry += '.default'
        child_age = true
    else if ta == 'family_nuclear_family'
      if offer.gender_first_part_of_stamp != null && offer.gender_second_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
      else if offer.gender_first_part_of_stamp != null
        locale_entry += ".#{offer.gender_first_part_of_stamp}.default"
      else if offer.gender_second_part_of_stamp != null
        locale_entry += ".special_#{offer.gender_second_part_of_stamp}"
      else
        locale_entry += '.default'
        append_age = false
    else if ta == 'family_everyone' || ta == 'refugees_families'
      append_age = false
    # console.log locale_entry
    stamp += I18n.t(locale_entry)
    if offer.age_visible && append_age
      stamp += @generateAgeForStamp(offer, child_age, current_section)
    stamp

  generateAgeForStamp: (offer, child_age, current_section) ->
    return '' if !offer._age_filters || offer._age_filters.length < 1
    from = offer._age_filters[0]
    to = offer._age_filters[offer._age_filters.length - 1]
    age_string = if child_age then "#{I18n.t('js.search_results.stamp.age.of_child')} " else ''
    if from == 0
      age_string += "#{I18n.t('js.search_results.stamp.age.to')} #{to}"
    else if to == 99 || current_section == 'family' && to > 17
      age_string += "#{I18n.t('js.search_results.stamp.age.from')} #{from}"
    else if from == to
      age_string += "#{from}"
    else
      age_string += "#{from} - #{to}"
    " (#{age_string} #{I18n.t('js.search_results.stamp.age.suffix')})"
