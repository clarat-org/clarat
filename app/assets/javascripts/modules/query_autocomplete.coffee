ready = ->
  if $('.typeahead').length
    initTypeahead()

    $(document).on 'newGeolocation', ->
      Clarat.typeahead.data('ttTypeahead').
        dropdown.datasets[0].source = generateSource() # don't ask

    Clarat.typeahead.on 'typeahead:selected', navigateToHit

initTypeahead = ->
  Clarat.index = new AlgoliaSearch(
    Clarat.algolia_app_id,
    Clarat.algolia_pub_key
  ).initIndex(
    Clarat.algolia_index
  )

  template = HoganTemplates['autocomplete']

  # typeahead.js (re)initialization
  $('.typeahead').typeahead 'destroy'
  Clarat.typeahead = $('.typeahead').typeahead null,
    source: generateSource()
    templates:
      suggestion: (hit) ->
        template.render(hit) # render the hit using Hogan.js

generateSource = ->
  Clarat.index.ttAdapter
    hitsPerPage: 5
    aroundLatLng: Clarat.currentGeolocation # TODO: use entered location
    aroundRadius: 999999999
    aroundPrecision: 500

navigateToHit = (event, suggestion, id) ->
  Turbolinks.visit "/angebote/#{suggestion.slug}"

$(document).ready ready
$(document).on 'page:load', ready
