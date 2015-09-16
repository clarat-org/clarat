# TODO: gueltige werte fuer category?
class Clarat.Search.Query.Base
  PER_PAGE: 20
  BASE_PRECISION: 500

  constructor:
    (@query = '', @category = null, @facetFilters = [], @page = null) ->

  query_hash: ->
    _.merge @page_query(),
      query: @query
      params:
        tagFilters: @category
        facets: '_age_filters,_target_audience_filters,_language_filters'
        facetFilters: @facetFilters
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
