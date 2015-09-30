# TODO: gueltige werte fuer category?
class Clarat.Search.Query.Base
  PER_PAGE: 20
  BASE_PRECISION: 500

  constructor:
    (@query = '', @category = null, @facet_filters = [], @page = null) ->

  query_hash: ->
    @categoryHelper = []
    if @category != null && @category != ""
      @categoryHelper.push @category
    _.merge @page_query(),
      query: @query
      params:
        tagFilters: @categoryHelper
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
