$('.user-popup').replaceWith(
  "<%= j render('/contacts/popup', contact: @contact) %>"
);