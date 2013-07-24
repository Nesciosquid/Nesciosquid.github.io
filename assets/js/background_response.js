$(function(){

	//Set main banner class in response to browser size, with background image partial class-string as imput.
	function setBackgroundImage() {
		var window_width = $(window).width();
		var target = $('body');		

		if (window_width > 980) {
			target.addClass("desktop-bg");
		}

		if (window_width < 980 && window_width >= 768) {
			target.addClass("tablet-bg");
		}

		if (window_width < 768) {
			target.addClass("phone-bg");
		}
	}
	//Determine proper class to apply to background on page load.
	setBackgroundImage();

	$(window).resize(function() {
	setBackgroundImage();
	});

});
