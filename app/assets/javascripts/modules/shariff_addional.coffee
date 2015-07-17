shariffExpand = ->

  $buttons = $('.shariff-button')

  $buttons.hover ->

    $buttons.removeClass "shariff-button--expanded"
    $(this).addClass "shariff-button--expanded"

  , ->
    $buttons.addClass "shariff-button--expanded"

$(document).on 'page:load', shariffExpand
$(document).ready shariffExpand
