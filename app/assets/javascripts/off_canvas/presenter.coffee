# Handle off canvas menu on offer index mobile

Clarat.OffCanvas = {}
class Clarat.OffCanvas.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      resize: 'resizeHandler'
    document:
      'Clarat.Search::NewResults': 'newResultsHandler'
    '.off-canvas-container__trigger':
      click: 'toggleHandler'

  constructor: ->
    super()

    @resizeHandler()
    @initTabs()
    @initInputStyling()
    @detectSwipeRight()

  detectSwipeRight: () =>

    hammertime = new Hammer(document.getElementById('off-canvas-container'))
    hammertime.on 'swipeleft', () =>
      @toggleHandler()


  initInputStyling: () =>
    $('input').iCheck()


  newResultsHandler: (event, resultSet) =>
    @resizeHandler()
    @getResultsCountFromMainResults(event, resultSet)

  resizeHandler: ->

    _.delay((->

      $offCanvasContainer = $('#off-canvas-container')
      $tabFilter = $offCanvasContainer.find('#tab_filter')
      $tabCategories = $offCanvasContainer.find('#tab_categories')
      $advancedSearch = $('#advanced_search')
      $categories = $('#categories')
      $asideStandard = $('.aside-standard:first')
      $listingResults = $('.Listing-results:first')
      $asideStandardContainer = $('.aside-standard__container') # quasi map
      $tabMap = $('#tab_map')

      if $(window).width() < 750
        # Put categories in offcanvascontainer
        $categories.appendTo $tabCategories
        # Put $advancedSearch in offcanvascontainer
        $advancedSearch.appendTo $tabFilter
        # Put map in tab map in Off C
        $asideStandardContainer.appendTo $tabMap
        $('#map-container').trigger 'Clarat.GMaps::Resize'
        window.dispatchEvent new Event('resize')


      else
        # Put categories in aside
        $categories.prependTo $asideStandard
        # Put $advancedSearch above Listing-results
        $advancedSearch.insertBefore $listingResults
        # Put map to sidebar again
        $asideStandardContainer.appendTo $asideStandard
      return
    ), 50, this)


  toggleHandler: =>
    $('#off-canvas-container').toggleClass 'active'
    $('#map-container').trigger 'Clarat.GMaps::Resize'
    window.dispatchEvent new Event('resize')

    $('body').toggleClass 'offcanvas-active'

  getResultsCountFromMainResults: (event, resultSet) =>
    @getResultsCount event, resultSet.results[0], resultSet.results[1]

  getResultsCount: (event, remote, pers) =>

    remoteHits = remote?.nbHits || 0
    persHits = pers?.nbHits || 0

    resultText = I18n.t('js.search_results.off_canvas.result_text',
                        result_count: (remoteHits + persHits))

    $('.off-canvas-container__result-text').text(resultText)


  initTabs: ->

    tabs = $('.tablist__tab')
    tabPanels = $('.tablist__panel')

    tabs.on 'click', ->

      thisTab = $(this)
      thisTabPanelId = thisTab.attr('aria-controls')
      thisTabPanel = $('#' + thisTabPanelId)
      tabs.attr('aria-selected', 'false').removeClass 'is-active'
      thisTab.attr('aria-selected', 'true').addClass 'is-active'
      tabPanels.attr('aria-hidden', 'true').addClass 'is-hidden'
      thisTabPanel.attr('aria-hidden', 'false').removeClass 'is-hidden'

    # Add enter key to the basic click event
    tabs.on 'keydown', (e) ->
      thisTab = $(this)
      if e.which == 13
        thisTab.click()

$(document).on 'ready', ->
  new Clarat.OffCanvas.Presenter
