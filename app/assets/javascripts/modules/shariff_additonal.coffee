shariffAdditional = ->

  $buttons = $('.shariff-button')

  $('.shariff').find('a[href^="mailto"]').attr('target', '_blank')

  $buttons.hover ->

    $buttons.removeClass "shariff-button--expanded"
    $(this).addClass "shariff-button--expanded"

  , ->
    $buttons.addClass "shariff-button--expanded"

$(document).on 'page:load', shariffAdditional
$(document).ready shariffAdditional
