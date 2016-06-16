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
      $tabMap = $offCanvasContainer.find('#tab_map')
      $advancedSearch = $('#advanced_search')
      $categories = $('#categories')
      $map = $('#map-container')
      $asideStandard = $('.aside-standard:first')
      $asideStandardMap = $('.aside-standard:eq(1)')
      $listingResults = $('.Listing-results:first')

      if $(window).width() < 750
        # Put categories in offcanvascontainer
        $categories.appendTo $tabCategories
        # Put $advancedSearch in offcanvascontainer
        $advancedSearch.appendTo $tabFilter
        # Put $advancedSearch in mapcontainer
        $map.appendTo $tabMap
      else
        # Put categories in aside
        $categories.prependTo $asideStandard
        # Put $advancedSearch above Listing-results
        $advancedSearch.insertBefore $listingResults
        # Put categories in aside
        $map.prependTo $asideStandardMap
      return
    ), 50, this)


  toggleHandler: =>
    $('#off-canvas-container').toggleClass 'active'
    $('body').toggleClass 'offcanvas-active'

  getResultsCountFromMainResults: (event, resultSet) =>
    @getResultsCount event, resultSet.results[0], resultSet.results[1]

  getResultsCount: (event, remote, pers) =>

    remoteHits = remote?.nbHits || 0
    persHits = pers?.nbHits || 0

    hits = +remoteHits + +persHits


    $('.off-canvas-container__number').text(hits + "\xa0")
    

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

