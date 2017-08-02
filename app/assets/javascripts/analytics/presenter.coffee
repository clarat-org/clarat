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

    if ($('body').hasClass('de'))
      @automatedTranslation = 'de'
    else
      @automatedTranslation = $('div').hasClass('Automated-translation')

    startHover = $.now()

    $('dfn.JS-tooltip').hover (->
      startHover = $.now()
    ), ->
      endHover = $.now()
      keyword = $(this).html()
      sHovered = (endHover - startHover)/1000
      if (sHovered) >= 1
        $(this).addClass(' hovered')
        if !$(this).attr('timeHovered') || $(this).attr('timeHovered') < sHovered
          $(this).attr( 'timeHovered', sHovered )

  onBeforeUnload: =>
    if $('dfn.JS-tooltip.hovered').length > 0
      keyword = $('dfn.JS-tooltip.hovered').html()
      time = $('dfn.JS-tooltip.hovered').attr('timeHovered')
      ga?(
        'send', 'event', 'TooltipRead', 'hoverout', 'tooltipActive:true;' +
        "keyword:#{keyword}", time
      )

    ga?('send', 'timing', 'PageView', 'total', @pageViewTime)

    if @goalOffset
      ga?(
        'send', 'event', 'PageView', 'unload',
        "goalViewed:#{!!@goalViewed};hadToScrollToGoal:#{!!@hasToScroll};" +
        "didScroll:#{!!@didScroll};" +
        "isGoogleTranslation:#{@automatedTranslation};",
        @pageViewTime
      )


$(document).ready ->
  new Clarat.Analytics.Presenter
