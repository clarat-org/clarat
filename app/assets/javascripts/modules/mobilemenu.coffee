initMobileMenu = ->

  $homeTemplate = $("body.template--pages-home").length
  $offersTemplate = $("body[class^='template--offers-']").length
  $inputLocation = $("#search_form_search_location")
  $inputQuery = $("#search_form_query")
  $submit = $(".main-search__submit")
  $header = $(".header-main")
  smartphone = ($(window).width() < 480)

  $inputLocation.removeClass "visible"

  if $homeTemplate
    return

  if $offersTemplate && smartphone
    $header.append "<a class='jump-to-tags' href='#tags'>#{I18n.t('js.navigate_to_tags')}</a>"


  if Modernizr.touch && smartphone

    $inputQuery.click ->
      $inputLocation.toggleClass "visible"
      $submit.toggleClass "enlarged"


$(document).ready initMobileMenu
