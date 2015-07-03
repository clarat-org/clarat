# Frontend Search Implementation - Model
# Patterns: Model-Template-Controller structure
class Clarat.Search.Model extends ActiveScript.Model
  # We communicate with a remote service instead of a database. This is the
  # equivalent of a regular #save. We create a connection, then send the data
  send: ->
    @client().search @queries()

  client: ->
    return @_client ?= algoliasearch Clarat.Search.appID, Clarat.Search.apiKey

  ### PRIVATE METHODS (ue) ###

  queries: ->
    return @_queries if @_queries
    # ,facet_query
    @_queries = _.chain([@personal_query(), @remote_query(), @nearby_query()])
      .compact()
      .map (query) -> query.query_hash()
      .value()

  personal_query: ->
    if @isPersonal()
      new Clarat.Search.PersonalQuery(
        @geolocation, @query, @category, @facet_filters, @page
      )

  remote_query: ->
    new Clarat.Search.RemoteQuery(
      @geolocation, @isPersonal(), @query, @category, @facet_filters, @page
    )

  nearby_query: ->
    new Clarat.Search.NearbyQuery @geolocation

  # facet_query: ->
  #   new Clarat.Search.FacetQuery @facet_query_attrs()
  #     query: @query,
  #     category: @category,
  #     geolocation: @geolocation,
  #     search_radius: @search_radius,
  #     facet_filters: @facet_filters


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
