$('#unavailable_location_overlay').popup('hide');
$('body').prepend(
  $('<div class="alert alert-success fade in">').html(
    I18n.t('js.update_request_success')
  )
);
