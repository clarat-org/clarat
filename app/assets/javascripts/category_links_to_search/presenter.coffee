Clarat.CategoryLinksToSearch = {}
class Clarat.CategoryLinksToSearch.Presenter extends ActiveScript.Presenter

  ### Start Page needs category links updated from autocomplete changes ###

  # TO DO: Fix, not working yet.
  CALLBACKS:
    'button.test':
      click: 'setHiddenFieldAndSubmit'

  setHiddenFieldAndSubmit: (event) =>
    # ... Setting hidden field ...
    category =event.target.dataset['category']
    #alert(category)
    console.log(category)
    $('input[name="search_form[category]"]').val(category)
    $('#new_search_form').submit();

$(document).ready ->
  Clarat.CategoryLinksToSearch.presenter = new Clarat.CategoryLinksToSearch.Presenter