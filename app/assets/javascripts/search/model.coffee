# Frontend Search Implementation - Model
# Communicates with the Persister, called by the Presenter.
# Patterns: Model-Template-Controller structure
class Clarat.Search.Model extends ActiveScript.Model
  # We communicate with a remote service instead of a database. This is the
  # equivalent of a regular #save. We create a connection, then send the data

  getMainSearchResults: ->
    @client().search @personalAndRemoteQueries()

  getLocationSupportResults: ->
    @client().search @nearbyAndFacetQueries()

  getQuerySupportResults: ->
    @client().search @facetQueries()

  client: ->
    return @_client ?= algoliasearch Clarat.Algolia.appID, Clarat.Algolia.apiKey

  ### PRIVATE METHODS (ue) ###

  nearbyAndFacetQueries: ->
    _.map [@nearby_query(), @personal_facet_query(), @remote_facet_query()],
          (query) -> query.query_hash()

  facetQueries: ->
    _.map [@personal_facet_query(), @remote_facet_query()],
          (query) -> query.query_hash()

  personalAndRemoteQueries: ->
    @_queries = _.chain [ @personal_query(), @remote_query() ]
      .compact()
      .map( (query) -> query.query_hash() )
      .value()

  personal_query: ->
    if @isPersonal()
      new Clarat.Search.Query.Personal(
        @generated_geolocation, @query, @category, @facet_filters(), @page
      )

  remote_query: ->
    new Clarat.Search.Query.Remote(
      @generated_geolocation, @isPersonal(), @query, @category, @facet_filters(),
      @page
    )

  nearby_query: ->
    new Clarat.Search.Query.Nearby @generated_geolocation

  personal_facet_query: ->
    new Clarat.Search.Query.PersonalFacet(
      @generated_geolocation, @query, @category, @facet_filters()
      # @query, @category, @geolocation, @search_radius, @facet_filters()
    )

  remote_facet_query: ->
    new Clarat.Search.Query.RemoteFacet(
      @generated_geolocation, true, @query, @category, @facet_filters()
    )


  isPersonal: ->
    @contact_type == 'personal'

  # snippet from advanced search branch
  ADVANCED_SEARCH_FILTERS: [
    'section' # add more filter names here
  ]

  facet_filters: ->
    @ADVANCED_SEARCH_FILTERS.map((type) =>
      filter = @[type]
      if filter then "_#{type}_filters:#{filter}" else null
    ).filter (element) -> element # compact / remove all falsey values

  # # wide radius or use exact location
  # search_radius: ->
  #   if search_form.exact_location
  #     100
  #   else
  #     50_000

  categoryWithAncestors: ->
    @findCategory(@categoryTree, @category)

  findCategory: (array, name) ->
    unless typeof array is 'undefined'
      for element in array
        return [name] if (element.name is name)

        a = @findCategory(element.set, name)
        if a?
          a.unshift(element.name)
          return a

    return null
