Clarat.ContactForm = {}
class Clarat.ContactForm.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '#new_contact':
      'ContactForm::CreateSuccess': 'handleSuccess'
    '.JS-ContactForm-Button__finish':
      click: 'resetForm'

  handleSuccess: (e) =>
    $('.Contact-Submit').trigger('Clarat.ContactForm::CreateSuccess')

    $('#new_contact').find('span.error').remove()
    @toggleContactFormVisibility('hide')
    $('.Contact-Submit').addClass('JS-ContactForm-Button__finish')
    $('.success_message').show()
    $('.js-report-overlay_close').addClass('greenOverlay')

    if @isFullPageContact()
      $('.back_to_hp').show()

  resetForm: (e) =>
    $('.Contact-Submit').trigger('Clarat.ContactForm::Reset')

    @toggleContactFormVisibility('show')
    $('.Contact-Submit').removeClass 'JS-ContactForm-Button__finish'
    $('.success_message').hide()
    $('.js-report-overlay_close').removeClass('greenOverlay')
    $('.back_to_hp').hide()
    $('#new_contact')[0].reset()

  ### private ###

  isFullPageContact: ->
    window.location.href.indexOf('kontakt') > -1

  toggleContactFormVisibility: (method) ->
    $('.contact_name')[method]()
    $('.contact_email')[method]()
    $('.contact_city')[method]()
    $('.contact_message')[method]()
    $('.contact_heading')[method]()


$(document).ready ->
  new Clarat.ContactForm.Presenter
