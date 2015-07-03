# Frontend Search Implementation - Presenter
# The presenter handles communication between the view and the model.
# It's like a rails Controller, but also handles requests from the view (JS
# callbacks)
# Patterns: Singleton instance; Model-Template-Presenter structure
class Clarat.Search.Presenter extends ActiveScript.Presenter
  ### PUBLIC "ACTIONS" ###

  # Search#new is rendered by ruby as Offers#index

  ###
  Creating a search means that we compile the available parameters into
  a search query and instead of sending (saving) it to our database, we send
  it to a remote search index, which returns aus the completed search objects
  for the show view. That means #show can't be called directly without #create
  as it's not persisted.
  ###
  create: =>
    search = new Clarat.Search.Model @params()
    search.send().then(@show).catch(@failure)

  ### PRIVATE "ACTIONS" (not enforced) ###

  # Rendered upon successful create.
  show: (resultSet) =>
    @render 'search_results', new Clarat.Search.ShowViewModel(resultSet)

  CALLBACKS:
    '#search_form_query':
      keyup: 'create'
    '.JS-CategoryLink':
      click: 'handleCategoryClick'
    '.JS-MoreLink':
      click: 'handleMoreClick'

  ### PRIVATE METHODS (not enforced) ###

  # Error view, rendered in case of any create/show exceptions.
  failure: (error) =>
    console.log error
    @render 'error_ajax', I18n.t('js.ajax_error')

  # parameters from form fields on page
  params: ->
    # TODO: call persister from model
    Clarat.Search.persister.load()
    # TODO: Params don't update


  ## Callbacks

  handleCategoryClick: (event) =>
    console.log 'cat clicked'
    # TODO: update category params
    @create()
    event.preventDefault()
    false

  handleMoreClick: (event) =>
    # TODO: update contact_type params
    console.log 'more clicked'
    @create()
    event.preventDefault()
    false

Clarat.Search.presenter = Clarat.Search.Presenter.get()

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
