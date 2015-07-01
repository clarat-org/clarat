# Frontend Search Implementation - Controller
# Patterns: Singleton instance; Model-Template-Controller structure
class Clarat.Search.Controller extends ActiveScript.Controller
  ### PUBLIC "ACTIONS" ###

  # Search#new is rendered by ruby as Offers#index

  ###
  Creating a search means that we compile the available parameters into
  a search query and instead of sending (saving) it to our database, we send
  it to a remote search index, which returns aus the completed search objects
  for the show view. That means #show can't be called directly without #create
  as it's not persisted.
  ###
  create: ->
    search = new Clarat.Search.Model @params()
    search.send().then(@show).catch(@failure)

  ### PRIVATE "ACTIONS" (not enforced) ###

  # Rendered upon successful create.
  show: (resultSet) =>
    personalResults = resultSet.results[0]
    remoteResults = resultSet.results[1]
    nearbyResults = resultSet.results[2]

    @render 'search_results',
      personal_focus_with_remote: true # TODO
      has_two_or_more_remote_results: remoteResults.nbHits > 1
      remote_results_headline: I18n.t('js.search_results.remote_offers', count: remoteResults.nbHits)
      personal_results_headline: I18n.t('js.search_results.personal_offers', count: personalResults.nbHits)
      more_anchor: I18n.t('js.search_results.more')
      more_href: window.location.href #offers_path(search_form: search_cache.remote_focus)
      show_on_big_map_anchor: I18n.t('js.search_results.show_on_big_map')
      main_offers: personalResults.hits
      personal_count: personalResults.nbHits
      remote_offers: remoteResults.hits
      translate: @translateString

  ### PRIVATE METHODS (not enforced) ###

  # Error view, rendered in case of any create/show exceptions.
  failure: (error) =>
    console.log error
    @render 'error_ajax', I18n.t('js.ajax_error')

  # parameters from form fields on page
  params: ->
    geolocation: document.getElementById('search_form_generated_geolocation').value
    query: document.getElementById('search_form_query').value
    category: document.getElementById('search_form_category').value
    facet_filters: [] # TODO

Clarat.Search.controller = new Clarat.Search.Controller


$('#search_form_query').on 'keyup', ->
  Clarat.Search.controller.create()

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
