# TODO: gueltige werte fuer category?
class BaseQuery
  attr_reader :query, :category, :filters, :page

  # TODO: category
  # TODO: filters used?
  def initialize(query: '', category:, filters: [], page: nil)
    @query = query
    @category = category
    @filters = filters
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

  # TODO: used? not working?
  def facet_filters
    filters
    #   .reject { |_key, value| value }
    #   .map { |type, filter| "_#{type}_filters:#{filter}" }
    #   .compact
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
