# TODO: gueltige werte fuer category?
class BaseQuery
  attr_reader :query, :category, :facet_filters, :page

  def initialize(query: '', category: nil, facet_filters: [], page: nil)
    @query = query
    @category = category
    @facet_filters = facet_filters
    @page = page
  end

  def query_hash
    {
      query: query,
      tagFilters: category,
      facets: '_age_filters,_audience_filters,_language_filters',
      facetFilters: facet_filters,
      aroundPrecision: 500
    }.merge(page_query)
  end

  def page_query
    if page
      {
        page: page,
        hitsPerPage: SearchResults::PER_PAGE
      }
    else
      {}
    end
  end
end
