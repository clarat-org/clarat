Clarat.MapModal = {}

class Clarat.MapModal.Presenter extends ActiveScript.Presenter
  constructor: ->
    @mapContainer = $('.template--offers-index #map-container')
    return null unless @mapContainer.length

    super()

    @mapModalContainer = $('#big-map')
    @mapCanvas = $('#map-canvas')

    @modal = @mapModalContainer.popup
      opacity: 0.3
      transition: 'all 0.3s'
      onopen: @handleModalOpen
      onclose: @handleModalClose

  CALLBACKS: {}

  # On Open: Enlarge Map
  handleModalOpen: =>
    @mapCanvas.css 'height', '100%'
    @mapCanvas.appendTo @mapModalContainer # move into inner modal container

    google.maps.event.trigger Clarat.currentMap.instance, 'resize'
    Clarat.GMaps.Map.setMapBounds()

  # On Close: Revert Map
  handleModalClose: =>
    @mapCanvas.css 'height', 300 # or inital
    @mapCanvas.appendTo @mapContainer # move back to original place

    google.maps.event.trigger Clarat.currentMap.instance, 'resize'
    # Set original bounds
    Clarat.GMaps.Map.setMapBounds()
