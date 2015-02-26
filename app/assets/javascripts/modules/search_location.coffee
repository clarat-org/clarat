registerSearchLocationHandlers = ->
  if $('.JS-Search-location').length
    $(document).on 'newGeolocation', updateLocationInput

  if $('.nav-sections__list').length
    updateCategoryLinksPeriodically()

$(document).ready registerSearchLocationHandlers
$(document).on 'page:load', registerSearchLocationHandlers

updateLocationInput = ->
  if Clarat.currentGeolocationByBrowser and
     not readCookie('last_search_location')
    $('.JS-Search-location').attr 'value', Clarat.currentGeolocation
    $('.JS-Search-location-display').attr(
      'value', I18n.t('conf.current_location')
    )

updateCategoryLinksPeriodically = ->
  # on input change by typing or places autocomplete
  $('#search_form_search_location').on 'input', updateCategoryLinks
  $('#search_form_generated_geolocation').on 'input', updateCategoryLinks
  google.maps.event.addListener(
    Clarat.placesAutocomplete, 'place_changed', updateCategoryLinks
  )
  # in 1 sec interval to catch other changes
  categoryUpdateInterval = setInterval updateCategoryLinks, 1000
  $(document).on 'page:before-change', -> clearInterval categoryUpdateInterval

updateCategoryLinks = ->
  search_location = $('#search_form_search_location').val()
  generated_geolocation = $('#search_form_generated_geolocation').val()

  for link in $('.nav-sections__listitem a')
    originalHref = link.href
    [originalBase, originalParams] = originalHref.split '?'
    $.query.spaces = true
    changedHref =
      $.query.parseNew originalParams
        .set 'search_form[search_location]', search_location
        .set 'search_form[generated_geolocation]', generated_geolocation
        .toString()
        .replace /%2B/g, '%20' # fix $.query tendency to convert space to plus

    link.href = originalBase + changedHref
