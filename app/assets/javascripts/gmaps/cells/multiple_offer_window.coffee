# Frontend Search Implementation - ViewModel for Search Template
class Clarat.GMaps.Cell.MultipleOfferWindow
  constructor: (@markerData) ->
    return viewObject =
      title: I18n.t 'js.map_info_window_multiple.title'
      text: I18n.t 'js.map_info_window_multiple.text'
      anchor: I18n.t 'js.map_info_window_multiple.anchor'
      url: @_generateExactSearchUrl @markerData

  ### PRIVATE ###

  _generateExactSearchUrl: (markerData) ->
    location.origin + location.pathname + $.query.set(
      'search_form[generated_geolocation]',
      "#{markerData.position.latitude},#{markerData.position.longitude}"
    ).set(
      'search_form[search_location]', "#{markerData.address}"
    ).set(
      'search_form[exact_location]', 'true'
    ).toString()
    .replace /%2B/g, '%20'
    # ^ fix $.query tendency to convert space to plus
