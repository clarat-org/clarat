Clarat.MapModal = {}

class Clarat.MapModal.Presenter extends ActiveScript.Presenter
  constructor: ->
    @mapContainer = $('#map-container')
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
    @initialMapHeight = @mapCanvas.height()
    @mapCanvas.css 'height', '100%'
    @mapCanvas.appendTo @mapModalContainer # move into inner modal container

    $('#map-container').trigger 'Clarat.GMaps::Resize'

  # On Close: Revert Map
  handleModalClose: =>
    @mapCanvas.css 'height', @initialMapHeight
    @mapCanvas.appendTo @mapContainer # move back to original place

    # Set original bounds
    $('#map-container').trigger 'Clarat.GMaps::Resize'

    $('#map-container').trigger 'Clarat.MapModal::Close'
