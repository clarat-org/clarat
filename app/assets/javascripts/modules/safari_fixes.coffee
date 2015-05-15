ready = ->

  if $('form .nav-sections').length
    $('form .nav-sections').insertAfter '#new_search_form'

  if navigator.userAgent.search('Safari') >= 0 and
     navigator.userAgent.search('Chrome') < 0

    # fix Safari frontend validation
    forms = document.getElementsByTagName 'form'
    for form in forms
      form.noValidate = true

      form.addEventListener 'submit', (event) ->
        if not event.target.checkValidity()
          event.preventDefault()
          Clarat.Flash.createFlash 'alert', I18n.t('js.location_required')
      , false

  true

$(document).on 'page:load', ready
$(document).ready ready
