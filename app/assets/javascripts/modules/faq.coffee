$(document).ready ->
  $('.FAQ_question').click ->
    $(this).next().toggle('slow')

  $('.FAQ_anchor_link').click ->
    event.preventDefault()
    $('html, body').animate { scrollTop: $(this.hash).offset().top }, 1000
    $(this.hash).click()
