$(document).ready ->
  $('.FAQ_question').click ->
    $(this).next().toggle('slow')
