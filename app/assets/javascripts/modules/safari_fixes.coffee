ready = ->

  if $('form .nav-sections').length
    $('form .nav-sections').insertAfter '#new_search_form'

  if navigator.userAgent.search('Safari') >= 0 and
     navigator.userAgent.search('Chrome') < 0

    forms = document.getElementsByTagName 'form'
    for form in forms
      form.noValidate = true

      form.addEventListener 'submit', (event) ->
        if not event.target.checkValidity()
          event.preventDefault()
          $('.page-wrap').prepend(
            HoganTemplates['flash_message'].render
              type: 'alert'
              message: I18n.t 'js.location_required'
          )
      , false

  true

$(document).on 'page:load', ready
$(document).ready ready
