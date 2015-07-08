# To find out result counts of possible future queries
class Clarat.Search.Query.Facet extends Clarat.Search.Query.Personal
  query_hash: ->
    _.merge super,
      params:
        facets: '_tags',
        page: 0,
        hitsPerPage: 1,
        tagFilters: ''
