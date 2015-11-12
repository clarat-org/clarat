# We have a string like "New York City" and need to get geocoordinates for
# that. A Rails API will provide them.
class Clarat.Location.Operation.RequestGeolocationForString
  @run: (requestedLocation, callback) ->

    # request coordinates for entered String
    if requestedLocation isnt '' # and requestedLocation isnt I18n.t('conf.current_location')

      $.get "/search_locations/#{encodeURIComponent(requestedLocation)}.json",
        (response) ->
          # if there was still no location request
          unless Clarat.currentGeolocationByBrowser
            callback(response)
