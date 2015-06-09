cookieWarning = ->
  if readCookie('userAcceptsCookies') isnt 'true'
    $('body').append HoganTemplates['cookie_warning'].render
      content: I18n.t 'js.cookie_warning_html'

    $('.JS-Cookie-warning--close').on 'click', ->
      $('.JS-Cookie-warning').remove()
      createCookie 'userAcceptsCookies', 'true', 89 # valid for 89 days

$(document).ready cookieWarning
$(document).on 'page:load', cookieWarning
