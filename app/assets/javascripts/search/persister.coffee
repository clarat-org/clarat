###
This object acts as a bridge between the unpersisted nature of JavaScript and
the expectations of users, that their choices are still applied after a reload
or HTTP request:

- When a user reloads the page, he expects to be where he was before. To
  accomplish that, we update the history when parameters change.
- Certain things like the selected location are required to be kept even longer.
  We set cookies for that. (Happens in Location Micro-App)
- When a user presses the search button, he issues a new HTML request and the
  data inside JS is lost. Thus when search parameters change, search form fields
  need to be updated.
- The above also implies, that we need to load the initial state of the JS
  search parameters from the form. (RoR will take care of syncing the form
  contents to the URL parameters.)

Think of it as the database, that the model interacts with.
###
class Clarat.Search.Persister extends ActiveScript.SingleInstance

  LOADABLE_FIELDS: [ # form fields
    'query', 'category', 'generated_geolocation', # , 'geolocation'
    'exact_location', 'contact_type', 'search_location',
    'age', 'target_audience', 'exclusive_gender', 'language'
  ]

  ### PUBLIC METHODS ###

  save: (changes) ->
    @updateURL changes
    @updateSearchForm changes
    @updateLinks changes

  # Rails loads from URL params and cookies into the search form,
  # JS loads from the search form.
  load: ->
    _.merge @getParamsFromSearchForm(), @getAdditionalParams()

  ### PRIVATE METHODS (ue) ###

  ## Savers

  updateURL: (changes) ->
    if window.history?.replaceState # only in supported browsers
      window.history.replaceState {}, '', @modifiedUrlString(changes)

  updateSearchForm: (changes) ->
    for field in @LOADABLE_FIELDS
      $("#search_form_#{field}").val changes[field] if changes[field]?

  updateLinks: (changes) ->
    # TODO: right click on link -> "open in new tab" should work in every state

  ## Loaders

  getParamsFromSearchForm: ->
    paramHash = {}
    for field in @LOADABLE_FIELDS
      paramHash[field] = document.getElementById("search_form_#{field}").value
    return paramHash

  # Load from places other than the search form
  getAdditionalParams: ->
    paramHash =
      # cat-tree & filters get transmitted as JSON in a hidden element
      categoryTree: $('#category-tree').data('structure').set
      filters: $('#filters').data('structure')

      # TODO: where do we get page from? URL params?
      page: 0

  ## Other

  modifiedUrlString: (attributesToChange) ->
    $.query.spaces = true

    changedHref = $.query
    for attribute, value of attributesToChange
      changedHref = changedHref.set "search_form[#{attribute}]", value

    changedHref = changedHref.toString().replace /%2B/g, '%20'
    # ^ fix $.query tendency to convert space to plus

    return window.location.href.split('?')[0] + changedHref


Clarat.Search.persister = new Clarat.Search.Persister
