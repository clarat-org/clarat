ready = ->
  if $('.typeahead').length
    initTypeahead()

    $(document).on 'newGeolocation', ->
      Clarat.typeahead.data('ttTypeahead').
        dropdown.datasets[0].source = generateSource() # don't ask

    Clarat.typeahead.on 'typeahead:selected', navigateToHit

    $('body').on 'click', '.tt-allresults', ->
      $('.main-search__submit').trigger 'click'

initTypeahead = ->
  Clarat.index = new AlgoliaSearch(
    Clarat.algolia_app_id,
    Clarat.algolia_pub_key
  ).initIndex(
    Clarat.algolia_index
  )

  hitTemplate = HoganTemplates['autocomplete']
  footerTemplate = HoganTemplates['footer']

  # typeahead.js (re)initialization
  $('.typeahead').typeahead 'destroy'
  Clarat.typeahead = $('.typeahead').typeahead null,
    source: generateSource()
    templates:
      suggestion: (hit) ->
        hitTemplate.render(hit) # render the hit using Hogan.js
      footer: (set) ->
        unless set.isEmpty
          footerTemplate.render
            content: I18n.t 'js.autocomplete_footer',
              results: Clarat.ttTotalResults
              query: set.query

generateSource = ->
  Clarat.ttAdapter
    hitsPerPage: 5
    aroundRadius: 999999999
    aroundPrecision: 500

navigateToHit = (event, suggestion, id) ->
  Turbolinks.visit "/angebote/#{suggestion.slug}"

# Write own ttAdapter so we can store number of total resuls
Clarat.ttTotalResults = undefined
Clarat.ttAdapter = (params) ->
  (query, cb) ->
    params['aroundLatLng'] = Clarat.currentGeolocation #<- difference to Algolia
    Clarat.index.search(
      query,
      (success, content) ->
        if success
          Clarat.ttTotalResults = content.nbHits # <- difference to Algolia
          cb(content.hits)
      , params
    )

$(document).ready ready
$(document).on 'page:load', ready
