# TODO: gueltige werte fuer category?
class Clarat.Search.BaseQuery
  PER_PAGE: 3 # 20
  BASE_PRECISION: 500

  constructor:
    (@query = '', @category = null, @facet_filters = [], @page = null) ->

  query_hash: ->
    _.merge @page_query(),
      query: @query
      params:
        tagFilters: @category
        facets: '_age_filters,_audience_filters,_language_filters'
        facetFilters: @facet_filters
        aroundPrecision: @BASE_PRECISION

  page_query: ->
    if @page?
      {
        params:
          page: @page
          hitsPerPage: @PER_PAGE
      }
    else
      {}
