$(function(){

	//Set main banner class in response to browser size, with background image partial class-string as imput.
	function setSize(image) {
		var window_width = $(window).width();
		var target = $('#main-banner');		

		if (window_width > 980) {
			target.removeClass().addClass("hero-unit banner-desktop " + image.desktop);
		}

		if (window_width < 980 && window_width >= 768) {
			target.removeClass().addClass("hero-unit banner-tablet " + image.tablet);
		}

		if (window_width < 768) {
			target.removeClass().addClass("banner-phone " + image.phone);
		}
	}

	//Retrieve array of image objects from #main-banner data.
	var image_types = $('#main-banner').data('banners');

	//Select a random image from the array to use 
	var image_index =Math.round(Math.random() * (image_types.length - 1));
	var banner_image = image_types[image_index];
	
	//Determine proper class to apply to banner on page load.
	setSize(banner_image);

	//Re-determine banner class wwhen window is resized.
	$(window).resize(function() {
		setSize(banner_image);
	});
});
