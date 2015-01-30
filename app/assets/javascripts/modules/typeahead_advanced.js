// TODO: coffeescript
// TODO: part of query_autocomplete
// TODO: I18n
ready = function(){

	if ($('.twitter-typeahead').length) {

		var ttContainer = $('.tt-dropdown-menu'),
			moreLink = $('<div class="tt-allresults">');

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

};

$(document).on('page:load', ready);
$(document).ready(ready);
