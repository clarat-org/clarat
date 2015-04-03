initMobileMenu = ->

  $inputQuery = $("#search_form_query")
  $homeTemplate = $("body.template--pages-home").length
  $inputLocationContainer = $(".search_form_search_location")
  $submit = $(".main-search__submit")
  $distributor = $(".Distributor--navigation")
  smartphone = ($(window).width() < 480)
  resultsHeadlineHeight = $(".Listing-results__headline").height()

  if $homeTemplate
    return

  if smartphone

    $inputQuery.click ->
      $inputLocationContainer.toggleClass "is-visible"
      $submit.toggleClass "is-enlarged"
      $distributor.toggleClass "is-enlarged"

    $(".content-main").css "padding-top", resultsHeadlineHeight + 90


$(document).on 'page:load', initMobileMenu
$(document).on 'ajax_loaded', initMobileMenu
$(document).ready initMobileMenu
$(window).resize initMobileMenu


