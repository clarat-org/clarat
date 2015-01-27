ready = function() {

	if ($('form .nav-sections').length) {
		$('form .nav-sections').insertAfter("#new_search_form");
	}

	if (navigator.userAgent.search('Safari') >= 0 && navigator.userAgent.search('Chrome') < 0) {
		var forms = document.getElementsByTagName('form');
		for (var i = 0; i < forms.length; i++) {
			forms[i].noValidate = true;

			forms[i].addEventListener('submit', function (event) {
				if (!event.target.checkValidity()) {
					event.preventDefault();
					$('.page-wrap').prepend('<div class="Flash-message Flash-message--alert">Bitte Ort angeben</div>');
				}
			}, false);
		}
	}
};

$(document).on('page:load', ready);
$(document).ready(ready);




