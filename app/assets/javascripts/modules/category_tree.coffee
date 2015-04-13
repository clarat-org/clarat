clickHandler = ->
  resultContainer = $('.content-main')

  $('.Categories a').on 'click', (event) ->
    that = $(this)
    url = that.attr 'href'

    $('.Categories__list').find('.active').removeClass('active')
    that.parents('li').addClass 'active'

    Clarat.ajaxReplace resultContainer, url

    $(document).trigger 'ajax_replaced'

    event.preventDefault()
    false

$(document).ready clickHandler
$(document).on 'page:load', clickHandler
