# TODO: gueltige werte fuer category?
class Clarat.Search.Query.Base
  PER_PAGE: 20
  BASE_PRECISION: 500
  VALUES_PER_FACET: 300 # must be >= Category.Count to avoid missing categories

  constructor:
    (@query = '', @category = null, @facetFilters = [], @page = null,
      @sort_order = 'nearby') ->
      # Algolia seems to want this string in an array
      @categoryArray = if @category then [@category] else []

  query_hash: ->
    _.merge @page_query(),
      query: @query
      params:
        tagFilters: @categoryArray
        facets: '_age_filters,_target_audience_filters,_language_filters'
        facetFilters: @facetFilters
        aroundPrecision: @_precisionPerSortOrder()
        maxValuesPerFacet: @VALUES_PER_FACET

  page_query: ->
    if @page?
      {
        params:
          page: @page
          hitsPerPage: @PER_PAGE
      }
    else
      {}

  _precisionPerSortOrder: ->
    if @sort_order == 'nearby'
      @BASE_PRECISION
    else
      @SEARCH_RADIUS || 50000
