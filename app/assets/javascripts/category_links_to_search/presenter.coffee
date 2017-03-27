Clarat.CategoryLinksToSearch = {}
class Clarat.CategoryLinksToSearch.Presenter extends ActiveScript.Presenter

  ### Start Page needs category links updated from autocomplete changes ###

  CALLBACKS:
    '.nav-sections__button':
      click: 'setHiddenFieldAndSubmit'

  setHiddenFieldAndSubmit: (event) =>
    # ... Setting hidden field ...
    category = event.target.dataset['category']

    # Fire this only when location empty
    if $('input[name="search_form[search_location]"]').val() is ""
      $('.nav-sections__notification').remove()
      $('<div class="nav-sections__notification"><i class="fa fa-exclamation" aria-hidden="true"></i></div>').insertBefore $(event.target)

    $('input[name="search_form[category]"]').val(category)
    $('#new_search_form').submit()
    $( document.body ).scrollTop( 0 )

$(document).ready ->
  Clarat.CategoryLinksToSearch.presenter = new Clarat.CategoryLinksToSearch.Presenter
