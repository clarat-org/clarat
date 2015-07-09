# To find out result counts of possible future queries
class Clarat.Search.Query.RemoteFacet extends Clarat.Search.Query.Remote
  query_hash: ->
    _.merge super(),
      params:
        facets: '_tags',
        page: 0,
        hitsPerPage: 1,
        tagFilters: ''
