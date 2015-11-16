# Initialization for anything that requires the GMaps library. `initialize` will
# be called when the library has finished loading.
Clarat.GMaps =
  Cell: {}
  Operation: {}

  loaded: false

  initialize: -> # callback for when maps script is loaded from google
    Clarat.GMaps.loaded = true

    # init PlacesAutocomplete on every page
    Clarat.GMaps.PlacesAutocomplete.initialize()

    # init map if there is a canvas
    if document.getElementById('map-canvas')
      Clarat.GMaps.presenter = new Clarat.GMaps.Presenter()
