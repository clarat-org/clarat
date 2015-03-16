clickHandler = ->
  categoryLink = $('.Categories__listitem.depth--0 > a')
  resultContainer = $('.content-main')

  categoryLink.on 'click', (event) ->
    that = $(this)
    url = that.attr 'href'

    event.preventDefault()

    if that.parent(".depth--0").length
      $('.depth--0.active').removeClass 'active'

    that.parent().addClass 'active'

    $.get url, (data) ->
      resultContainer.html data

$(document).ready clickHandler
$(document).on 'page:load', clickHandler
