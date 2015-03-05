clickHandler = ->
  categoryLink = $('.Categories__listitem a')
  resultContainer = $('.content-main')

  categoryLink.on 'click', (event) ->
    that = $(this)
    url = that.attr 'href'

    event.preventDefault()

    $('.Categories__listitem .Categories__list li').removeClass 'active'
    that.parent().addClass 'active'

    $.get url, (data) ->
      resultContainer.html data

$(document).ready clickHandler
$(document).on 'page:load', clickHandler