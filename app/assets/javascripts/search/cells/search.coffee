# Frontend Search Implementation - ViewModel for Search Template
class Clarat.Search.Cell.Search
  constructor: (@model) ->
    return viewObject =
      headline_small_map: I18n.t('js.search_results.map.headline_small_map')
      enlarge_map_anchor: I18n.t('js.search_results.map.enlarge_map')
      more_label: I18n.t('js.search.form_more_label')
      headline_sort_order: I18n.t('js.search.headlines.sort')
      headline_age: I18n.t('js.search.headlines.age')
      headline_language: I18n.t('js.search.headlines.language')
      headline_target_audience: I18n.t('js.search.headlines.target_audience')
      headline_gender: I18n.t('js.search.headlines.gender')
      headline_residency_status: I18n.t('js.search.headlines.residency_status')
      headline_approach: I18n.t('js.search.headlines.approach')
      option_any: I18n.t('js.search.option_any')
      tab_filter: I18n.t('js.search.tabs.filter')
      tab_map: I18n.t('js.search.tabs.map')
      reset_label: I18n.t('js.search.reset_label')

      filters: @model.getFilters()
      current_section: @model.section_identifier
