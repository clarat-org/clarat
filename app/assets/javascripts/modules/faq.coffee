faqClickHandlers = ->

  # Corrects triggered scroll value (1) if small mediaquery
  # since header's fixed position there calls for offset
  offsetCorrection = if ($(window).width() < 480) then 84 else 0

  $('.FAQ_question').click ->
    $(this).next().toggle('slow')

  $('.FAQ_anchor_link').on 'click', (event)->
    event.preventDefault()

    $('html, body').animate {
      scrollTop: $(this.hash).offset().top - offsetCorrection # (1)
    }, 1000

    $(this.hash).click()

$(document).ready faqClickHandlers
$(document).on 'page:load', faqClickHandlers
$(window).resize faqClickHandlers
