# Module for handling Google Analytics related events

Clarat.Analytics = {}
class Clarat.Analytics.Presenter extends ActiveScript.Presenter
  constructor: ->
    super()
    @onLoad()
    @setupGoalTracking()
    window.onbeforeunload = @onBeforeUnload

  CALLBACKS:
    'a[href^="http"]':
      click: 'trackClick'
    document:
      'Clarat::GMaps::placesAutocompleteTriggered':
        'detectPlacesAutocompleteTriggered'

  trackClick: (e) =>
    $(e).each =>
      @trackOutboundLink(e.target.href)
    return true


  trackOutboundLink: (url) =>
    ga? 'send', 'event', 'outbound', 'click', url,
      'transport': 'beacon'
      # 'hitCallback': ->
      #   document.location = url
      #   return


  detectPlacesAutocompleteTriggered: =>
    place = Clarat.GMaps.PlacesAutocomplete.instance.getPlace()

    if place
      ga?(
        'send', 'event', 'field', 'changed', 'places_autocomplete',
        metric1: place.formatted_address
      )

  setupGoalTracking: =>
    @goalOffset = $('#scroll-goal').offset()?.top
    if @goalOffset
      unless @onScroll(null, true)
        $(window).on 'scroll', @onScroll

  onScroll: (event, initialCall = false) =>
    windowTop = $(window).scrollTop()
    windowHeight = $(window).height()
    windowBottom = windowTop + windowHeight
    if event then @didScroll = true
    if initialCall then @hasToScroll = @goalOffset > windowHeight
    if (@goalOffset <= windowBottom)
      @goalViewed = true
      $(window).off 'scroll', @onScroll
      true
    else
      false

  onLoad: ->
    @pageViewTime = 0
    ifvisible.onEvery 0.5, =>
      @pageViewTime += 500

  onBeforeUnload: =>
    ga?('send', 'timing', 'PageView', 'total', @pageViewTime)
    if @goalOffset
      ga?(
        'send', 'event', 'PageView', 'unload',
        "goalViewed:#{!!@goalViewed};hadToScrollToGoal:#{!!@hasToScroll};" +
        "didScroll:#{!!@didScroll};",
        @pageViewTime
      )


$(document).ready ->
  new Clarat.Analytics.Presenter
