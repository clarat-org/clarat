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
      @markers[key]['ids'] << object.id
    else
      @markers[key] =
        position:
          latitude: object._geoloc.lat
          longitude: object._geoloc.lng
        ids: [object.id]
        url: "#{location.pathname}/#{object.slug}"
        title: object.name
        address: object.location_address
        organization_display_name: object.organization_display_name
