function callSize(rand) {
	var winwid = $(window).width();

	if (winwid > 980) {
		$('.heuck-banner').removeClass().addClass("heuck-banner hero-unit banner-desktop");
		if (rand == 1) {
			$('.heuck-banner').addClass('d-wet');
		}
		else {
			$('.heuck-banner').addClass('d-fist');
		}

	}

	if (winwid < 980 && winwid >= 768) {
		$('.heuck-banner').removeClass().addClass("heuck-banner hero-unit banner-tablet t-fist");
	}

	if (winwid < 768) {
		$('.heuck-banner').removeClass().addClass("heuck-banner banner-phone p-fist");
	}
}

$(function(){
	var random = Math.round(Math.random()*1);
	callSize(random);
	$(window).resize(callSize(random));
});

