$(window).load(function() {
	$('.homeslide').flexslider({
	    animation: "slide",
	    pauseOnHover: true
	});

	$('.moreInfo').mouseover(function () {

	    $('.flex-active-slide .slideOverlay').addClass('on');
	    $('.flex-active-slide .slideText').addClass('on');

	  });

	$('.homeslide').mouseleave(function () {

	    $('.slideOverlay').removeClass('on');
	    $('.slideText').removeClass('on');
	    
	 });

	$('.flex-direction-nav a').click(function () {

	    $('.slideOverlay').removeClass('on');
	    $('.slideText').removeClass('on');
	    
	 });


$('.DecadesTab').click(function() {

  $(this).addClass('selected');
  $('.yearTab').removeClass('selected');

  $('.timelineContainer').hide();
  $('.Decades').show();
 

  return false;

});

$('.yearTab').click(function() {

  $(this).addClass('selected');
  $('.DecadesTab').removeClass('selected');

  $('.Decades').hide();
  $('.timelineContainer').show();

  return false;
  
});


$('.timelineModule').slider();

	$('.next').click(function() {
		if($(this).parent().next().hasClass('timeline-row')) {
			$('.timelineContainer').animate({
		    	right: '+=100.1%'
		  	}, 500);

		} else {
			//DON'T MOVE
		}
	});

	$('.prev').click(function() {
		if($(this).parent().prev().hasClass('timeline-row')) {
			$('.timelineContainer').animate({
		    	right: '-=100.1%'
		  	}, 500);

		} else {
			//DON'T MOVE
		}
	});
	
});

$('#toggle').toggle( 
    function() {
        $('aside').addClass('moveOut');
        $('.slidePopOut').addClass('moveIn');
        $('.map article, .timeline article').addClass('widthL');
        $('#toggle').html('Refine <span aria-hidden="true" class="icon-arrow-thin-right"></span>');


        $('aside').removeClass('moveIn');
        $('.slidePopOut').removeClass('moveOut');
        $('.map article, .timeline article').removeClass('widthS');
    }, 
    function() {
        $('aside').addClass('moveIn');
        $('.slidePopOut').addClass('moveOut');
        $('.map article, .timeline article').addClass('widthS');
        $('#toggle').html('<span aria-hidden="true" class="icon-arrow-thin-left"></span> Refine');

        $('aside').removeClass('moveOut');
        $('.slidePopOut').removeClass('moveIn');
        $('.map article, .timeline article').removeClass('widthL');
    }
);








$('#toggle.Marticle').click( function() {
    $('aside').addClass('moveIn');
    $('.map article').addClass('moveOut');

    $('aside').removeClass('moveOut');
    $('.map article').removeClass('moveIn');
});

$('#toggle.Maside').click( function() {
    $('aside').addClass('moveOut');
    $('.map article').addClass('moveIn');

    $('aside').removeClass('moveIn');
    $('.map article').removeClass('moveOut');
});












$('.mapContainer').click(function() {
  $('.mobile-hover').hide();
  $('.map iframe').animate({ height: '300px' }, 'slow');
});
 

  $('.open').toggle(
  function(){
      $(this).next('.slidingDiv').slideUp();
      $(this).addClass('close');
  },
  function(){
    $(this).next('.slidingDiv').slideDown();
    $(this).removeClass('close');
  }
);


$('.slide-container').toggle(
  function(){
      $('.flex-active-slide .slideOverlay').addClass('on');
      $('.flex-active-slide .slideText').addClass('on');
  },
  function(){
      $('.flex-active-slide .slideOverlay').removeClass('on');
      $('.flex-active-slide .slideText').removeClass('on');
  }
);


$('.pop-columns li').toggle(
  function(){
    $(this).children('ul').slideDown();
  },
  function(){
    $(this).children('ul').slideUp();
  }
);





$('.menu-btn').toggle(
  function(){
    $('.topNav, .MainNav').slideDown();
  },
  function(){
    $('.topNav, .MainNav').slideUp();
  }
);



//Examples of how to assign the ColorBox event to elements
$(".inline").colorbox({inline:true, width:"50%"});
        


