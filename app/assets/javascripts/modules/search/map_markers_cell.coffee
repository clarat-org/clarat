# TODO: What is this in our pattern?
class Clarat.Search.MapMarkersCell
  constructor: (@mainResults) ->
    return @markersViewObject()

  markersViewObject: =>
    @markers = {}
    collection = @mainResults

    for element in collection
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
        url: "/angebote/#{object.slug}"
        title: object.name
        address: object.location_address
        organization_display_name: object.organization_display_name
