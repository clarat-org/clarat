$(document).ready ->
  algolia = new AlgoliaSearch(document.Clarat.algolia_app_id, document.Clarat.algolia_pub_key)
  document.Clarat.index = algolia.initIndex(document.Clarat.algolia_index)

  initTypeahead()

  $(document).on 'newGeolocation', initTypeahead

initTypeahead = ->
  console.log 'initTypeahead'
  # Mustache templating by Hogan.js (http://mustache.github.io/)
  template = HoganTemplates['autocomplete']

  # typeahead.js (re)initialization
  $('.typeahead').typeahead 'destroy'
  $('.typeahead').typeahead null,
    source: document.Clarat.index.ttAdapter
      hitsPerPage: 5
      aroundLatLng: document.Clarat.currentGeolocation
      aroundRadius: 999999999
    displayKey: 'name'
    templates:
      suggestion: (hit) ->
        # select matching attributes only
        hit.matchingAttributes = [] # DELETE IF NOT NEEDED

        # render the hit using Hogan.js
        template.render(hit)
