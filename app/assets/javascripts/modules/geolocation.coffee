document.Clarat.currentGeolocation = I18n.t('conf.default_latlng') # default: middle of Berlin

document.Clarat.getGeolocation = ->
  navigator.geolocation.getCurrentPosition (position) ->
    document.Clarat.currentGeolocation =
      "#{position.coords.latitude},#{position.coords.longitude}"
    #console.log document.Clarat.currentGeolocation
    $(document).trigger 'newGeolocation'

document.Clarat.getGeolocation()
