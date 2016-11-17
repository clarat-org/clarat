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
      unless @onScroll()
        $(window).on 'scroll', @onScroll

  onScroll: =>
    windowTop = $(window).scrollTop()
    windowBottom = windowTop + $(window).height()
    if (@goalOffset <= windowBottom)
      @onGoalAreaViewed()
      $(window).off 'scroll', @onScroll
      true
    else
      false

  onGoalAreaViewed: ->
    console.log 'scrolling goal reached'
    ga?(
      'send', 'event', 'PageView', 'contact_person_viewed',
      'Goal Reached: Contact Person Area Displayed'
    )

  onLoad: ->
    @pageViewTime = 0
    ifvisible.onEvery 0.5, =>
      @pageViewTime += 500

  onBeforeUnload: =>
    ga?('send', 'timing', 'PageView', 'total', @pageViewTime)


$(document).ready ->
  new Clarat.Analytics.Presenter
