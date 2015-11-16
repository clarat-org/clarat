# Frontend Search Implementation - ViewModel for Search Template
class Clarat.GMaps.Cell.MultipleOfferWindow
  constructor: (@markerData) ->
    return viewObject =
      title: I18n.t 'js.map_info_window_multiple.title'
      text: I18n.t 'js.map_info_window_multiple.text'
      anchor: I18n.t 'js.map_info_window_multiple.anchor'
      url: @_generateExactSearchUrl markerData.position

  ### PRIVATE ###

  _generateExactSearchUrl: (position) ->
    location.origin + location.pathname + $.query.set(
      'search_form[generated_geolocation]',
      "#{position.latitude},#{position.longitude}"
    ).set(
      'search_form[exact_location]', 't'
    ).toString()
