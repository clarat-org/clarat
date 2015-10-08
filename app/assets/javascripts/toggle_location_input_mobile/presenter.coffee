# Toggle visibility of location input on click in first

#Clarat.ToogleLocationInputMobile = {}
#class Clarat.ToogleLocationInputMobile.Presenter extends ActiveScript.Presenter
#
#  CALLBACKS:
#    '#search_form_query':
#      click: 'handleClick'
#
#  handleClick: () =>
#
#    $body = $('body')
#    $homeTemplate = $("body.template--pages-home").length
#    $inputLocationContainer = $(".search_form_search_location")
#    $submit = $(".main-search__submit")
#    $distributor = $(".Distributor--navigation")
#    smartphone = ($(window).width() < 1000)
#
#    if $homeTemplate
#      return
#
#    if smartphone
#      $inputLocationContainer.toggleClass "is-visible"
#      $submit.toggleClass "is-enlarged"
#      $distributor.toggleClass "is-enlarged"
#      $body.toggleClass "has-enlarged-header"
#
#
#$(document).on 'ready', ->
#  new Clarat.ToogleLocationInputMobile.Presenter

