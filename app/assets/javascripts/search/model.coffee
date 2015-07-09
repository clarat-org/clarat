# Frontend Search Implementation - Model
# Communicates with the Persister, called by the Presenter.
# Patterns: Model-Template-Controller structure
class Clarat.Search.Model extends ActiveScript.Model
  # We communicate with a remote service instead of a database. This is the
  # equivalent of a regular #save. We create a connection, then send the data

  getMainSearchResults: ->
    @client().search @personalAndRemoteQueries()

  getSupportSearchResults: ->
    @client().search @nearbyAndFacetQueries()

  client: ->
    return @_client ?= algoliasearch Clarat.Algolia.appID, Clarat.Algolia.apiKey

  ### PRIVATE METHODS (ue) ###

  nearbyAndFacetQueries: ->
    _.map [@nearby_query(), @personal_facet_query(), @remote_facet_query()],
          (query) -> query.query_hash()

  personalAndRemoteQueries: ->
    @_queries = _.chain [ @personal_query(), @remote_query() ]
      .compact()
      .map( (query) -> query.query_hash() )
      .value()

  personal_query: ->
    if @isPersonal()
      new Clarat.Search.Query.Personal(
        @geolocation, @query, @category, @facet_filters, @page
      )

  remote_query: ->
    new Clarat.Search.Query.Remote(
      @geolocation, @isPersonal(), @query, @category, @facet_filters, @page
    )

  nearby_query: ->
    new Clarat.Search.Query.Nearby @geolocation

  personal_facet_query: ->
    new Clarat.Search.Query.PersonalFacet(
      @geolocation, @query, @category, @facet_filters
      # @query, @category, @geolocation, @search_radius, @facet_filters
    )

  remote_facet_query: ->
    new Clarat.Search.Query.RemoteFacet(
      @geolocation, true, @query, @category, @facet_filters
    )


  isPersonal: ->
    @contact_type == 'personal'

  # facet_filters: ->
  #   @filters ||= %w(age audience language).map do |type|
  #     filter = search_form.send("#{type}_filter")
  #     "_#{type}_filters:#{filter}" if filter
  #   end.compact
  #
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
