class Clarat.Location.Operation.SaveToCookie
  @run: (searchLocation) ->
    @saveCookie 'saved_search_location', searchLocation['query']
    @saveCookie 'saved_geolocation', searchLocation['geoloc']

  ## Private Methods (ue) ##

  @saveCookie: (name, value) ->
    return unless value?
    # if value is ''
    #   eraseCookie name
    # else
    createCookie name, encodeURIComponent(value), 90
