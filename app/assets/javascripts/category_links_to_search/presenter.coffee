Clarat.CategoryLinksToSearch = {}
class Clarat.CategoryLinksToSearch.Presenter extends ActiveScript.Presenter

  ### Start Page needs category links updated from autocomplete changes ###

  CALLBACKS:
    '.nav-sections__button':
      click: 'setHiddenFieldAndSubmit'

  setHiddenFieldAndSubmit: (event) =>
    # ... Setting hidden field ...
    category = event.target.dataset['category']

    # Remove past markers
    $('.nav-sections__notification').remove()

    # Add alert marker to category when location is empty
    if $('input[name="search_form[search_location]"]').val() is ''
      @render event.target, 'category_alert_marker', {}, method: 'before'

    $('input[name="search_form[category]"]').val(category)
    $('#new_search_form').submit()
    $( document.body ).scrollTop( 0 )

$(document).ready ->
  Clarat.CategoryLinksToSearch.presenter =
    new Clarat.CategoryLinksToSearch.Presenter
