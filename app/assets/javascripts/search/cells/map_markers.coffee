# TODO: What is this in our pattern?
class Clarat.Search.Cell.MapMarkers
  constructor: (@mainResults) ->
    return @markersViewObject()

  markersViewObject: =>
    @markers = {}

    for element in @mainResults
      if element.location_visible
        @makeMarker element

    @markers

  makeMarker: (object) ->
    key = "#{object._geoloc.lat},#{object._geoloc.lng}"
    if @markers[key]
      # TODO fix this later!! (Ticket #342)
      @markers[key]['ids'].push(object.objectID)
      # @markers[key]['ids'] << object.objectID
    else
      @markers[key] =
        position:
          latitude: object._geoloc.lat
          longitude: object._geoloc.lng
        ids: [object.objectID]
        url: "#{location.pathname}/#{object.slug}"
        title: object.name
        address: object.location_address
        organization_display_name: if object.organization_count == 1 then object.organization_names else I18n.t("js.search_results.map.cooperation")
