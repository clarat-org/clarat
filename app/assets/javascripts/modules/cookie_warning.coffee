cookieWarning = ->
  if readCookie('userAcceptsCookies') isnt 'true'
    HandlebarsTemplates['cookie_warning']( content: I18n.t 'js.cookie_warning_html')
    $('body').addClass 'hasCookieWarning'

    $('.JS-Cookie-warning--close').on 'click', ->
      $('.JS-Cookie-warning').remove()
      $('body').removeClass 'hasCookieWarning'
      createCookie 'userAcceptsCookies', 'true', 89 # valid for 89 days

$(document).ready cookieWarning
$(document).on 'page:load', cookieWarning
