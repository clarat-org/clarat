$(document).ready ->
  $('.FAQ_question').click ->
    # debugger
    $(this).next().toggle('slow')

  $('.FAQ_anchor_link').click ->
    # debugger
    event.preventDefault()
    $(this.hash).click()
