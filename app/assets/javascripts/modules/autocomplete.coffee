$(document).ready ->
  if $('.typeahead').length
    initTypeahead()

    $(document).on 'newGeolocation', ->
      document.Clarat.typeahead.data('ttTypeahead').
        dropdown.datasets[0].source = generateSource() # don't ask

    document.Clarat.typeahead.on 'typeahead:selected', navigateToHit

initTypeahead = ->
  document.Clarat.index = new AlgoliaSearch(
    document.Clarat.algolia_app_id,
    document.Clarat.algolia_pub_key
  ).initIndex(
    document.Clarat.algolia_index
  )

  template = HoganTemplates['autocomplete']

  # typeahead.js (re)initialization
  $('.typeahead').typeahead 'destroy'
  document.Clarat.typeahead = $('.typeahead').typeahead null,
    source: generateSource()
    templates:
      suggestion: (hit) ->
        template.render(hit) # render the hit using Hogan.js

generateSource = ->
  document.Clarat.index.ttAdapter
    hitsPerPage: 5
    aroundLatLng: document.Clarat.currentGeolocation # TODO: use entered location
    aroundRadius: 999999999

navigateToHit = (event, suggestion, id) ->
  Turbolinks.visit "/angebote/#{suggestion.slug}"
