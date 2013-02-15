$(document).ready(function() {


  var resizeTimer;
  var TIMELINE_VIEW_WIDTH;
  var SCRUBBER_WIDTH;



	$('.homeslide').flexslider({
	    animation: "slide",
	    pauseOnHover: true
	});

	$('.moreInfo').mouseover(function () {
      $(this).addClass('hover');
      $('.flex-direction-nav a').addClass('hover');
	    $('.flex-active-slide .slideOverlay').addClass('on');
	    $('.flex-active-slide .slideText').addClass('on');
	});

	$('.homeslide').mouseleave(function () {
	    $('.slideOverlay').removeClass('on');
	    $('.slideText').removeClass('on');
      $('.moreInfo').removeClass('hover');
      $('.flex-direction-nav a').removeClass('hover');
	 });

	$('.flex-direction-nav a').click(function () {
	    $('.slideOverlay').removeClass('on');
	    $('.slideText').removeClass('on');
      $('.moreInfo').removeClass('hover');
      $('.flex-direction-nav a').removeClass('hover');
	});

  $('.DecadesTab').click(function() {
    $(this).addClass('selected');
    $('.yearTab').removeClass('selected');
    $('.timelineContainer').hide();
    $('.Decades').show();
    return false;
  });











  $('.search-btn').click(function() {
    $('.searchViews, .search-btn').addClass('off');
    $('.searchRowRight form').show().animate({width: '98%'}, 500);
    $('.search-form input[type="text"]').focus();

    $('.searchRowRight form, .searchViews, .search-btn').removeClass('on');
    return false;
  });



  $('.search-form input[type="text"]').blur(function() {
    $('.search-btn').addClass('on', function() {
      $('.searchViews').addClass('on');
    });

    $('.searchRowRight form').addClass('on');
  });














  $('.head').toggle(function() {
      $(this).next().slideDown();
      $(this).addClass('close');
    }, 
    function() {
      $(this).next().slideUp();
      $(this).removeClass('close');
    }
  );

  $('.yearTab').click(function() {
    $(this).addClass('selected');
    $('.DecadesTab').removeClass('selected');
    $('.Decades').hide();
    $('.timelineContainer').show();
    return false;
  });


  ///// REFINE SIDEBAR TOGGLE
  $('#toggle').toggle(function() {

      $('aside').addClass('moveOut');
      $('.slidePopOut').addClass('moveIn');
      $('.map article, .timeContainer').addClass('widthL');
      $('#toggle').html('Refine <span aria-hidden="true" class="icon-arrow-thin-right"></span>');

      $('aside').removeClass('moveIn');
      $('.slidePopOut').removeClass('moveOut');
      $('.map article, .timeContainer').removeClass('widthS');

    }, 
    function() {

      $('aside').addClass('moveIn');
      $('.slidePopOut').addClass('moveOut');
      $('.map article, .timeContainer').addClass('widthS');
      $('#toggle').html('<span aria-hidden="true" class="icon-arrow-thin-left"></span> Refine');

      $('aside').removeClass('moveOut');
      $('.slidePopOut').removeClass('moveIn');
      $('.map article, .timeContainer').removeClass('widthL');

    }
  );






  $('#toggle.Marticle').click( function() {
      $('aside').addClass('moveIn');
      $('.map article, .timeContainer, .slidePopOut').addClass('moveOut');
      $('#toggle.Marticle').hide();
      $('#toggle.Maside').show();

      $('aside').removeClass('moveOut');
      $('.map article, .timeContainer, .slidePopOut').removeClass('moveIn');
  });

  $('#toggle.Maside').click( function() {
      $('aside').addClass('moveOut');
      $('.map article, .timeContainer, .slidePopOut').addClass('moveIn');
      $('#toggle.Marticle').show();
      $('#toggle.Maside').hide();

      $('aside').removeClass('moveIn');
      $('.map article, .timeContainer, .slidePopOut').removeClass('moveOut');
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

  // $('.pop-columns li').toggle(
  //   function(){
  //     $(this).children('ul').slideDown();
  //   },
  //   function(){
  //     $(this).children('ul').slideUp();
  //   }
  // );

  $('.menu-btn').toggle(
    function(){
      $('.topNav, .MainNav').slideDown();
      $(this).html('<span aria-hidden="true" class="icon-arrow-thin-up"></span>');
    },
    function(){
      $('.topNav, .MainNav').slideUp();
      $(this).html('<span aria-hidden="true" class="icon-arrow-thin-down"></span>');
    }
  );

  /// REFRESH once the width is 680
  var ww = $(window).width();
  var limit = 640;

  function refresh() {
    ww = $(window).width();
    var w =  ww<limit ? (location.reload(true)) :  ( ww>limit ? (location.reload(true)) : ww=limit );
  }

  var tOut;

  $(window).resize(function() {
    var resW = $(window).width();
    clearTimeout(tOut);
    if ( (ww>limit && resW<limit) || (ww<limit && resW>limit) ) {        
        tOut = setTimeout(refresh);
    }
  });


  //LIGHT BOX
  $(".inline").colorbox({inline:true, top: '20px', width:"100%", maxWidth: "1000px", transition: "none"});

  $('.pop-open').click(function() {
    $('.pop-columns.country').fadeOut(function() {
      $('.pop-columns.states').fadeIn();
    });
  });

/////TIMELINE MODULE: YEARS
  $('.timeline-row .next').click(function() {
    if($(this).parent().next().hasClass('timeline-row')) {
      $('.prev, .next').hide();
      $('.timelineContainer').animate({ right: '+=100%' }, 500, function() { 
        $('.prev, .next').show();
      });
    }
  });

  $('.timeline-row .prev').click(function() {
    if($(this).parent().prev().hasClass('timeline-row')) {
      $('.prev, .next').hide();
      $('.timelineContainer').animate({ right: '-=100%' }, 500, function() { 
        $('.prev, .next').show(); 
      });
    }
  });


/////TIMELINE MODULE: SCRUBBER
  $('.scrubber').slider({
    value: 1000,
    min: 0,
    max: 1000,
    slide: function( event, ui ) {
      var move = ui.value / 10.91 + '%';
      $('.DecadesDates, .graph').css({ right: move });
    }
  });

  $('.scrubber a').append('<span class="arrow"></span>');

/////TIMELINE MODULE: DECADES

  var timelineDistance;
  var windowWidth = window.innerWidth || document.documentElement.clientWidth;
  
  // Calculate the screen width
  function getScreenWidth() {
	  if (windowWidth > 980) {
		  slideDistance = 6.85;
	  } else {
		  slideDistance = 0.56;
	  }
  }
  $(window).bind('resize',function(){
	getScreenWidth();
  });
  getScreenWidth();

  var moving = false;
  $('.Decades .prev').click(function() {
	if (moving == false) {
	  moving = true;
	  var moveDistance = Math.abs($('article.timeline').offset().left - $('.graph').offset().left);
	  if (moveDistance < $('.graph').width() * (slideDistance/100)) {
		  $('.DecadesDates, .graph').animate({ right: '0' }, function() { moving = false; });
		  $('.scrubber a').animate({ left: '0' });
		  $('.Decades .prev').hide();
	  } else {
		  $('.DecadesDates, .graph').animate({ right: '-=' +slideDistance+ '%' }, function() { moving = false; });
		  $('.scrubber a').animate({ left: '-=' +slideDistance+ '%' });
		  $('.Decades .prev').show();
		  $('.Decades .next').show();
	  }
	}
  });

  $('.Decades .next').click(function() {
	if (moving == false) {
	  moving = true;
	  var moveDistance = Math.abs($('.graph').offset().left + $('.graph').outerWidth() - ($('article.timeline').outerWidth() + $('article.timeline').offset().left));
	  if (moveDistance < $('.graph').width() * (slideDistance/100)) {
		$('.DecadesDates, .graph').animate({ right: '91.659%' }, function() { moving = false; });
		$('.scrubber a').animate({ left: '100%' });
		$('.Decades .next').hide();
	
	  } else {
		$('.DecadesDates, .graph').animate({ right: '+=' +slideDistance+ '%' }, function() { moving = false; });
		$('.scrubber a').animate({ left: '+=' +slideDistance+ '%' });
		$('.Decades .next').show();
		$('.Decades .prev').show();
	  }
	}
  });

       
});

