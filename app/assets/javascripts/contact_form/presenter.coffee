Clarat.ContactForm = {}
class Clarat.ContactForm.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    '#new_contact':
      formsent: 'handleSuccess'
    '.JS-Single-Click-Button__fin':
      click: 'resetForm'

  handleSuccess: (e) =>

      $('.Contact-Submit').trigger('finished');
      $('.Contact-Submit').addClass('JS-Single-Click-Button__fin');
      $('#new_contact').find('span.error').remove();
      $('.contact_heading').hide();
      $('.js-report-overlay_close').addClass('greenOverlay');
      $('.success_message').show();
      $('.contact_name').hide();
      $('.contact_email').hide();
      $('.contact_city').hide();
      $('.contact_message').hide();
      if window.location.href.indexOf('kontakt') > -1
        $('.back_to_hp').show();


  resetForm: (e) =>

    $sent = $(event.target).find('.JS-Single-Click-Button__original').html()
    $('.success_message').hide();
    $('.contact_name').show();
    $('.contact_email').show();
    $('.contact_city').show();
    $('.contact_message').show();
    $('.contact_heading').show();
    $('.back_to_hp').hide();
    $('.Contact-Submit').removeClass('JS-Single-Click-Button__active');
    $('.Contact-Submit').html($sent);
    $('.js-report-overlay_close').removeClass('greenOverlay');



$(document).ready ->
  new Clarat.ContactForm.Presenter
