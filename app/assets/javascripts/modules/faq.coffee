faqClickHandlers = ->

  # Corrects triggered scroll value (1) if small mediaquery
  # since header's fixed position there calls for offset
  offsetCorrection = if ($(window).width() < 480) then 84 else 0

  $('body').on 'click', '.FAQ_question', (event) ->
    $(this).next().toggle('slow')

  $('body').on 'click', '.FAQ_anchor_link', (event) ->
    event.preventDefault()

    $('html, body').animate {
      scrollTop: $(this.hash).offset().top - offsetCorrection # (1)
    }, 1000

    $(this.hash).click()

$(document).ready faqClickHandlers
# $(window).resize faqClickHandlers # TODO: Why? Causes bug.
