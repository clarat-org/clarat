class Clarat.Search.Concept.UpdateCategories
  @updateActiveClasses: (activeCategory)->
    $('.Categories__list').find('.active').removeClass('active')
    $('.Categories__list').find("a[data-name='#{activeCategory}']")
      .parents('li').addClass 'active'

  @updateCounts: (facetSet) ->
    if facetSet.facets? and facetSet.facets._tags?  # TODO: Why is this necessary?
      categoryFacets = facetSet.facets._tags
      for categoryLink in $("#categories li > a")
        $categoryLink = $(categoryLink)
        categoryName = $categoryLink.data('name')
        facetCount = categoryFacets[categoryName] || 0

        $categoryLink.html "#{categoryName} (#{facetCount})"
