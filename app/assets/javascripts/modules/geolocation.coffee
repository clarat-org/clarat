document.Clarat.currentGeolocation = '52.520007,13.404954' # default: middle of Berlin

document.Clarat.getGeolocation = ->
  navigator.geolocation.getCurrentPosition (position) ->
    document.Clarat.currentGeolocation = "#{position.coords.latitude},#{position.coords.longitude}"
    #console.log document.Clarat.currentGeolocation
    $(document).trigger 'newGeolocation'

document.Clarat.getGeolocation()
