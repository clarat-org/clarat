Clarat.enhanceListingResults = {}

class Clarat.enhanceListingResults.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '.Listing-results__expander':
      click: 'toggleHandler'
    document:
      'Clarat.Search::NewResults': 'initGlobeTooltip'

  toggleHandler: (event) =>

    that = event.currentTarget
    address = $(that).parent().parent().find ".Listing-results__meta" # .next() would search in the next result; preventing.

    $(address).toggleClass('is-expanded')

    $(that).attr 'aria-toggle', (i, attr) ->
      if attr == 'true' then 'false' else 'true'


  initGlobeTooltip: () =>
    $('.Listing-results__globe').qtip
      position:
        my: 'bottom left'
        at: 'top left'
        effect: false
        viewport: $(window)

$(document).ready ->
  new Clarat.enhanceListingResults.Presenter
