# Frontend Search Implementation - ViewModel for Search#show
# Handles almost all logic for the view.
# Is not based on the Search model, but the resultSet that the Presenter queries
# from the remote index.
# Patterns: Model-Template-Presenter structure
class Clarat.Search.ShowViewModel
  constructor: (@resultSet) ->
    personalResults = @resultSet.results[0]
    remoteResults = @resultSet.results[1]
    nearbyResults = @resultSet.results[2]

    return viewObject =
      personal_focus_with_remote: true # TODO
      has_two_or_more_remote_results: remoteResults.nbHits > 1
      remote_results_headline:
        I18n.t('js.search_results.remote_offers', count: remoteResults.nbHits)
      personal_results_headline:
        I18n.t('js.search_results.personal_offers',
               count: personalResults.nbHits)

      headline_small_map: I18n.t('js.search_results.map.headline_small_map')

      show_on_big_map_anchor: I18n.t('js.search_results.map.show_on_big_map')
      enlarge_map_anchor: I18n.t('js.search_results.map.enlarge_map')
      all_categories_anchor: I18n.t('js.categories_sidebar.all_categories')

      more_anchor: I18n.t('js.search_results.more')
      more_href: window.location.href # TODO: offers_path(search_form: search_cache.remote_focus)

      remote_offers: remoteResults.hits
      main_offers: personalResults.hits
      personal_count: personalResults.nbHits

      category_tree: @getCategoryTree()

  getCategoryTree: ->
    @_category_tree ?= $('#category-tree').data('structure').set
