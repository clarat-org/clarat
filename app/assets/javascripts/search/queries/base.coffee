# TODO: gueltige werte fuer category?
class Clarat.Search.Query.Base
  PER_PAGE: 20
  BASE_PRECISION: 500
  VALUES_PER_FACET: 300 # must be >= Category.Count

  constructor:
    (@query = '', @category = null, @facet_filters = [], @page = null) ->

  query_hash: ->
    @categoryHelper = if @category && @category != "" then [@category] else []
    _.merge @page_query(),
      query: @query
      params:
        tagFilters: @categoryHelper
        facets: '_age_filters,_audience_filters,_language_filters'
        facetFilters: @facet_filters
        aroundPrecision: @BASE_PRECISION
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
