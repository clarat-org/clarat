initMobileMenu = ->

  $body = $('body')
  $inputQuery = $("#search_form_query")
  $homeTemplate = $("body.template--pages-home").length
  $inputLocationContainer = $(".search_form_search_location")
  $submit = $(".main-search__submit")
  $distributor = $(".Distributor--navigation")
  smartphone = ($(window).width() < 1000)

  if $homeTemplate
    return

  if smartphone
    $inputQuery.unbind('click').click ->
      $inputLocationContainer.toggleClass "is-visible"
      $submit.toggleClass "is-enlarged"
      $distributor.toggleClass "is-enlarged"
      $body.toggleClass "has-enlarged-header"

$(document).on 'page:load', initMobileMenu
$(document).on 'ajax_loaded', initMobileMenu
$(document).ready initMobileMenu
$(window).resize initMobileMenu
