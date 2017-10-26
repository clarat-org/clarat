Clarat.SoftJump = {}
class Clarat.SoftJump.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '.Hero__link-to-explaination':
      click: 'handleClick'

  handleClick: () =>

    $('html, body').animate { scrollTop: $('#explaination').offset().top }, 500
    event.preventDefault()
    return


$(document).ready ->
  new Clarat.SoftJump.Presenter

