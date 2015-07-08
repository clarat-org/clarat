###
This object acts as a bridge between the unpersisted nature of JavaScript and
the expectations of users, that things still work after a reload:

- When a user reloads the page, he expects to be where he was before. To
  accomplish that, we update the history when parameters change.
- Certain things like the selected location are required to be kept even longer.
  We set cookies for that.
- When a user presses the search button, he issues a new HTML request and the
  data inside JS is lost. Thus when search parameters change, search form fields
  need to be updated.
- The above also implies, that we need to load the initial state of the JS
  search parameters from the form. (RoR will take care of syncing the form
  contents to the URL parameters.)

Think of it as the database, that the model interacts with.
###
# Pattern: Singleton
class Clarat.Search.Persister extends ActiveScript.Singleton

  LOADABLE_FIELDS: [
    'query', 'category', 'geolocation', 'generated_geolocation',
    'exact_location', 'contact_type', 'search_location' # TODO: facet_filters
  ]

  ### PUBLIC METHODS ###

  save: ->
    @updateURL()
    @updateSearchForm()
    @updateCookies()

  # Rails loads from URL params and cookies into the search form,
  # JS loads from the search form.
  load: ->
    _.merge @getParamsFromSearchForm(), @getAdditionalParams()

  ### PRIVATE METHODS (ue) ###

  updateURL: ->
    # TODO

  updateSearchForm: ->
    # TODO

  updateCookies: ->
    # TODO

  getParamsFromSearchForm: ->
    paramHash = {}
    for field in @LOADABLE_FIELDS
      paramHash[field] = document.getElementById("search_form_#{field}").value
    return paramHash

  # Load from places other than the search form
  getAdditionalParams: ->
    paramHash =
      # category tree gets transmitted as a JSON structure in a hidden element
      categoryTree: $('#category-tree').data('structure').set

      # TODO: where do we get page from? URL params?
      page: 0


Clarat.Search.persister = Clarat.Search.Persister.get()
