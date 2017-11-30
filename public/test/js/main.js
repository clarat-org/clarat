$('.accordion__toggle').click(function () {
  $(this).parent().toggleClass('closed');
});

$(document).ready(init);
$(window).resize(init);

function init() {

  if ($(window).width() < 800) {
    $('.accordion').addClass('closed')
  }
}
