Clarat.toggleListingResultAddress = {}

class Clarat.toggleListingResultAddress.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '.Listing-results__expander':
      click: 'handleClick'

  handleClick: (event) =>

    that = event.currentTarget
    address = $(that).parent().parent().find ".Listing-results__meta" # .next() would search in the next result; preventing.

    $(address).toggleClass('is-expanded')
    # Todo: that.toggleAria('expand')


$(document).ready ->
  new Clarat.toggleListingResultAddress.Presenter