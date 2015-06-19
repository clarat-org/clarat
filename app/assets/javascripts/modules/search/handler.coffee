# Frontend Search Implementation
class Clarat.Search.Handler
  constructor: ->
    ### PUBLIC ATTRIBUTES ###

    @client = algoliasearch Clarat.Search.appID, Clarat.Search.apiKey

    @personalIndex = @client.initIndex Clarat.Search.personalIndexName
    @remoteIndex = @client.initIndex Clarat.Search.remoteIndexName


  ### PUBLIC METHODS ###

  sendSearch: (query = '') ->
    @client.search([
      indexName: Clarat.Search.personalIndexName
      query: query
    ,
      indexName: Clarat.Search.remoteIndexName
      query: query
      params:
        hitsPerPage: 1
    ]).then(@searchSuccess).catch(@searchFailure)

  ### PRIVATE METHODS (not enforced) ###

  searchSuccess: (content) ->
    @personalResults = content.results[0]
    @remoteResults = content.results[1]

    console.log @personalResults.hits[0]
    $('.content-main').html(
      HandlebarsTemplates['search_results'](
        personal_focus_with_remote: true
        has_two_or_more_remote_results: true
        remote_offer_headline: "Remote Offer Headline" #t '.remote_offers', count: search.remote_hits.nbHits
        more_link: "(More)" #link_to t('.more'), offers_path(search_form: search_cache.remote_focus)
        main_offers: @personalResults.hits
        remote_offers: @remoteResults.hits
        translate: @translateString
      )
    )

  searchFailure: (error) ->
    console.log error

    $('.content-main').html(
      HandlebarsTemplates['error_ajax'] I18n.t('js.ajax_error')
    )

Handlebars.registerHelper
  # Translations in Handlebars. Make sure to provide a scope that contains at
  # least 'js'
  i18n: (string, options) ->
    I18n.t string, options.hash if string

  # Logic comparator. This goes against Handlebars conventions so use with care.
  ifDiffering: (string, options) ->
    if string is options.hash.from
      options.inverse this
    else
      options.fn this

Clarat.Search.handler = new Clarat.Search.Handler

$('#search_form_query').on 'keyup', ->
  Clarat.Search.handler.sendSearch @value

# class SearchManager
#   attr_reader :search_form, :page
#
#   delegate :query, :category, :geolocation, to: :search_form, prefix: false
#
#   def initialize(search_form, page: nil)
#     @search_form = search_form
#     @page =
#       [page.to_i - 1, 0].max # essentially "-1", normalize for algolia
#     # TODO: clarity
#   end
#
#   # TODO: rewrite hits[] to not be dependent on array ordering
#   def personal_hits
#     @personal ||= if search_form.contact_type == :personal
#                     SearchResults.new hits[0]
#                   end
#   end
#
#   # TODO: rewrite hits[] to not be dependent on array ordering
#   def remote_hits
#     @remote ||= SearchResults.new hits[-3]
#   end
#
#   # TODO: rewrite hits[] to not be dependent on array ordering
#   def nearby_hits
#     @nearby ||= SearchResults.new hits[-2]
#   end
#
#   # TODO: rewrite hits[] to not be dependent on array ordering
#   def facets_hits
#     @facets ||= SearchResults.new(hits[-1]).facets['_tags'] || {}
#   end
#
#   private
#
#   def hits
#     @hits ||= Algolia.multiple_queries(queries).fetch('results')
#   end
#
#   def queries
#     @queries ||= [personal_query, remote_query, nearby_query, facet_query]
#                  .compact
#                  .map(&:query_hash)
#   end
#
#   def personal_query
#     if personal?
#       PersonalQuery.new(personal_query_attrs)
#     end
#   end
#
#   def remote_query
#     RemoteQuery.new(remote_query_attrs)
#   end
#
#   def nearby_query
#     NearbyQuery.new(geolocation: geolocation)
#   end
#
#   def facet_query
#     FacetQuery.new(facet_query_attrs)
#   end
#
#   # This is where the translation between the domain model and
#   # the algolia model starts. this could be extracted to one/several
#   # translation object(s)
#
#   def personal_query_attrs
#     {
#       query: query,
#       category: category,
#       geolocation: geolocation,
#       search_radius: search_radius,
#       facet_filters: facet_filters,
#       page: page
#     }
#   end
#
#   def remote_query_attrs
#     {
#       query: query,
#       category: category,
#       geolocation: geolocation,
#       teaser: personal?,
#       facet_filters: facet_filters,
#       page: page
#     }
#   end
#
#   def facet_query_attrs
#     {
#       query: query,
#       category: category,
#       geolocation: geolocation,
#       search_radius: search_radius,
#       facet_filters: facet_filters
#     }
#   end
#
#   def personal?
#     search_form.contact_type == :personal
#   end
#
#   # TODO: this needs to be properly unit tested
#   def facet_filters
#     @filters ||= %w(age audience language).map do |type|
#       filter = search_form.send("#{type}_filter")
#       "_#{type}_filters:#{filter}" if filter
#     end.compact
#   end
#
#   # wide radius or use exact location
#   def search_radius
#     if search_form.exact_location
#       100
#     else
#       50_000
#     end
#   end
# end
