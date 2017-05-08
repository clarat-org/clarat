class Clarat.Search.Operation.UpdateCategories
  @updateActiveClasses: (activeCategory) ->
    $('.Categories__list').find('.active').removeClass('active')
    $('.Categories__list').find("a[data-name='#{activeCategory}']")
      .parents('li').addClass 'active'

  @updateCounts: (personalFacetSet, remoteFacetSet) ->
    personalCategoryFacets = personalFacetSet?.facets._categories || undefined
    remoteCategoryFacets = remoteFacetSet.facets._categories

    for categoryLink in $("#categories li > a")
      $categoryLink = $(categoryLink)
      categoryName = $categoryLink.data('name')

      facetCount =
        (personalCategoryFacets?[categoryName] || 0) +
        (remoteCategoryFacets?[categoryName] || 0)

      $categoryLink.html "#{categoryName} (#{facetCount})"
