$(function(){

	function setSize(style) {
		var winwid = $(window).width();
		var banner_class;
		if (winwid > 980) {
			banner_class = "d-" + style;
			$('.heuck-banner').removeClass().addClass("heuck-banner hero-unit banner-desktop " + banner_class);
		}

		if (winwid < 980 && winwid >= 768) {
			banner_class = "t-" + style;
			$('.heuck-banner').removeClass().addClass("heuck-banner hero-unit banner-tablet " + banner_class);
		}

		if (winwid < 768) {
			banner_class = "p-" + style;
			$('.heuck-banner').removeClass().addClass("heuck-banner banner-phone p-fist " + banner_class);
		}
	}

	var type;
	var number =Math.round(Math.random() * 1);
	if (number == 0)
	{
		type = "fist";
	}

	if (number == 1) 
	{
		type = "wet";
	}
	
	setSize(type);

	$(window).resize(function() {
		setSize(type);
	});
});
