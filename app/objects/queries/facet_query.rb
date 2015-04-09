class FacetQuery < PersonalQuery
  # TODO: needed?
  def initialize(args)
    super
  end

  def query_hash
    super.merge(
      facets: '_tags',
      page: 0,
      hitsPerPage: 1,
      tagFilters: ''
    )
  end
end
