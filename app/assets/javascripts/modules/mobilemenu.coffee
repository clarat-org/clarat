initMobileMenu = ->

  $homeTemplate = $("body.template--pages-home").length
  $offersTemplate = $("body[class^='template--offers-']").length
  $inputLocation = $("#search_form_search_location")
  $inputQuery = $("#search_form_query")
  $submit = $(".main-search__submit")
  $header = $(".header-main")
  $content = $(".content-main")
  smartphone = ($(window).width() < 480)
  $jumpLinkExists = $(".jump-to-tags")

  $inputLocation.removeClass "visible"

  if $homeTemplate
    return

  if $offersTemplate && smartphone && !$jumpLinkExists.length
    $content.find(".Listing-results__headline").after "<a class='jump-to-tags' href='#tags'><i class='fa fa-filter'></i>#{I18n.t('js.navigate_to_tags')}</a>"

  if !smartphone
    $jumpLinkExists.remove


  if Modernizr.touch && smartphone

    $inputQuery.click ->
      $inputLocation.toggleClass "visible"
      $submit.toggleClass "enlarged"


$(document).ready initMobileMenu
$(window).resize initMobileMenu
