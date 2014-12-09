$(function(){ // document ready
	var $sticky = $(".template--offers-index").find(".aside-standard");

	if (!!$sticky.offset()) {
		var stickyTop = $sticky.offset().top;
		$(window).scroll(function(){
			var windowTop = $(window).scrollTop();
			if (stickyTop < windowTop){
				$sticky.css({ position: 'fixed', top: 0 });
			} else {
				$sticky.css('position','static');
			}
		});
	}
	
});