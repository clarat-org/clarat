# To find out result counts of possible future queries
class Clarat.Search.Query.PersonalFacet extends Clarat.Search.Query.Personal
  query_hash: ->
    _.merge super(),
      params:
        facets: '_tags,_age_filters,_audience_filters,_language_filters',
        page: 0,
        hitsPerPage: 1,
        tagFilters: ''
