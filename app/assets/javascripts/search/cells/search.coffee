# Frontend Search Implementation - ViewModel for Search Template
class Clarat.Search.Cell.Search
  constructor: (@model) ->
    return viewObject =
      headline_small_map: I18n.t('js.search_results.map.headline_small_map')
      enlarge_map_anchor: I18n.t('js.search_results.map.enlarge_map')
      all_categories_anchor: I18n.t('js.categories_sidebar.all_categories')

      category_tree: @model.categoryTree
      filters: @model.filters
      current_section: @model.section
