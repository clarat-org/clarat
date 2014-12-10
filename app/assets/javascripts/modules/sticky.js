function initStickySidebar() {
	var $sticky = $(".template--offers-index").find(".aside-standard"),
		stickyWidth = $sticky.width();

	if ($(document).width() >= 900) {
		if (!!$sticky.offset()) {
			var stickyTop = $sticky.offset().top;

			$(window).scroll(function(){
				var footerInViewport = withinViewport($(".footer-main")),
					windowTop = $(window).scrollTop();

				if (stickyTop < windowTop){
					var top = (footerInViewport ? -140 : 0);
					$sticky.css(
						{
							position: 'fixed',
							top: top,
							width: stickyWidth
						});
				} else {
					$sticky
						.css('position', 'static')
						.css('width', '35.7%'); // chaining, because otherwise false top value
				}
			});
		}
	} else {
		$(window).scroll(function() {
			$sticky
				.css('position', 'static')
				.css('width', '35.7%'); // chaining, because otherwise false top value
		});
	}
}

$(window).resize(function(){
	initStickySidebar();
});

$(document).ready(function () {
	initStickySidebar();
});