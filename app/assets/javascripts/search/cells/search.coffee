# Frontend Search Implementation - ViewModel for Search Template
class Clarat.Search.Cell.Search
  constructor: (@model) ->
    return viewObject =
      headline_small_map: I18n.t('js.search_results.map.headline_small_map')
      enlarge_map_anchor: I18n.t('js.search_results.map.enlarge_map')
      all_categories_anchor: I18n.t('js.categories_sidebar.all_categories')
      more_label: I18n.t('js.search.form_more_label')
      headline_age: I18n.t('js.search.headlines.age')
      headline_language: I18n.t('js.search.headlines.language')
      headline_targt_audience: I18n.t('js.search.headlines.target_audience')
      headline_gender: I18n.t('js.search.headlines.gender')
      headline_approach: I18n.t('js.search.headlines.approach')
      option_any: I18n.t('js.search.option_any')

      category_tree: @model.categoryTree
      filters: @model.filters
      current_section: @model.section
