function initMobileMenu() {

	var $homeTemplate = $("body.template--pages-home").length,
		$offersTemplate = $("body[class^='template--offers-']").length,
		$inputLocation = $("#search_form_search_location"),
		$inputQuery = $("#search_form_query"),
		$submit = $(".main-search__submit"),
		$header = $(".header-main");

	if ($homeTemplate) {
		return;
	}

	$inputLocation.removeClass("visible");

	if ($offersTemplate) {
		$header.append("<a class='jump-to-tags' href='#tags'>Zum Schlagwortfilter</a>");
	}

	if (Modernizr.touch && ($(window).width() < 480)) {

		$inputQuery.click(function() {
			$inputLocation.toggleClass("visible");
			$submit.toggleClass("enlarged");
		});

	}

}

$(document).ready(function () {
	initMobileMenu();
});