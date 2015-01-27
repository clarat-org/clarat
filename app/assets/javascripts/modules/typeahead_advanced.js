$(window).load(function(){

	if ($('.twitter-typeahead').length) {

		var ttContainer = $('.tt-dropdown-menu'),
			moreLink = $('<div class="tt-allresults"></div>');

		ttContainer.append(moreLink);

		$('.tt-input').on('keyup', function () {
			refreshText($(this));
		});

		function refreshText(that) {
			moreLink.html('').html('Alle Suchergebnisse f&uuml;r \'' + that.typeahead('val') + '\'');
		}

		moreLink.on('click', function () {
			$('.main-search__submit').trigger('click');
		});
	}

});

