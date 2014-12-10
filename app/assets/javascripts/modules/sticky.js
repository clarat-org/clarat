function initStickySidebar() {
	var $sticky = $(".template--offers-index").find(".aside-standard");

	if ($(document).width() >= 900) {
		if (!!$sticky.offset()) {
			var stickyTop = $sticky.offset().top;

			$(window).scroll(function(){
				var footerInViewport = withinViewport($(".footer-main")),
					windowTop = $(window).scrollTop();

				if (stickyTop < windowTop){
					var top = (footerInViewport ? -140 : 0);
					$sticky.css({ position: 'fixed', top: top });
				} else {
					$sticky.css('position', 'static');
				}
			});
		}
	} else {
		$(window).scroll(function() {
			$sticky.css('position', 'static');
		});
	}
}

$(window).resize(function(){
	initStickySidebar();
});

$(document).ready(function () {
	initStickySidebar();
});