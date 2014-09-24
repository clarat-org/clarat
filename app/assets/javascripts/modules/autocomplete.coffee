$(document).ready ->
  # Replace the following values by your ApplicationID and ApiKey.
  algolia = new AlgoliaSearch(document.Clarat.algolia_app_id, document.Clarat.algolia_pub_key)
  # replace YourIndexName by the name of the index you want to query.
  index = algolia.initIndex(document.Clarat.algolia_index)

  # Mustache templating by Hogan.js (http://mustache.github.io/)
  template = HoganTemplates['autocomplete']

  # typeahead.js initialization
  $('.typeahead').typeahead null,
    source: index.ttAdapter({ hitsPerPage: 5 })
    displayKey: 'name'
    templates:
      suggestion: (hit) ->
        # select matching attributes only
        hit.matchingAttributes = []
        for attribute, matches of hit._highlightResult
          if attribute is 'name'
            # already handled by the template
            continue

          # all others attributes that are matching should be added in the matchingAttributes array
          # so we can display them in the dropdown menu. Non-matching attributes are skipped.
          if matches.matchLevel isnt 'none'
            hit.matchingAttributes.push
              attribute: attribute
              value: matches.value

        # render the hit using Hogan.js
        template.render(hit)
