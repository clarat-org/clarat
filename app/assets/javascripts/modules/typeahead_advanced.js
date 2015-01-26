if ($('.twitter-typeahead').length) {

	var that = $(this),
		ttContainer = $('.tt-dropdown-menu'),
		moreLink = $('<div class="tt-allresults"></div>');

	ttContainer.append(moreLink);

	$('.tt-input').on('keyup', function () {
		moreLink.html('').html('Alle Suchergebnisse für \'' + $(this).typeahead('val') + '\'');
	});

	moreLink.on('click', function () {
		that.parents('.search_form').trigger('submit');
	});

}

