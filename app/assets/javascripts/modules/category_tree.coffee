# Clarat.CategoryTree =
#   updateFacets: (facetsJSON) ->
#     for categoryLink in $("#categories li > a")
#       $categoryLink = $(categoryLink)
#       categoryName = $categoryLink.data('category')
#       facetCount = facetsJSON[categoryName] || 0
#
#       $categoryLink.html "#{categoryName} (#{facetCount})"
#
#   registerClickHandler: ->
#     resultContainer = $('.content-main')
#
#     $('.Categories a').on 'click', (event) ->
#       that = $(this)
#       url = that.attr 'href'
#
#       $('.Categories__list').find('.active').removeClass('active')
#       that.parents('li').addClass 'active'
#
#       Clarat.Ajax.replace resultContainer, url
#
#       event.preventDefault()
#       false
#
# $(document).ready Clarat.CategoryTree.registerClickHandler
# $(document).on 'page:load', Clarat.CategoryTree.registerClickHandler
