$(window).load(function() {

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
    $('.searchViews, .search-btn').hide();
    $('.searchRowRight form').show().animate({width: '98%'}, 500);
    $('.search-form input[type="text"]').focus();
    return false;
  });

  $('.search-form input[type="text"]').blur(function() {
    $('.search-btn').show(function() { $('.searchViews').fadeIn(); });
    $('.searchRowRight form').animate({width: '0%'}, 500);
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

  $('.next').click(function() {
    if($(this).parent().next().hasClass('timeline-row')) {
      $('.prev, .next').hide();
      $('.timelineContainer').animate({ right: '+=100.1%' }, 500, function() { $('.prev, .next').show(); });

    } else {
      //DON'T MOVE
    }
  });

  $('.prev').click(function() {
    if($(this).parent().prev().hasClass('timeline-row')) {
      $('.prev, .next').hide();
      $('.timelineContainer').animate({ right: '-=100.1%' }, 500, function() { $('.prev, .next').show(); });
    } else {
      //DON'T MOVE
    }
  });
  
  $('#toggle').toggle(function() {
      $('aside').addClass('moveIn');
      $('.slidePopOut').addClass('moveOut');
      $('.map article, .timeContainer').addClass('widthS');
      $('#toggle').html('Refine <span aria-hidden="true" class="icon-arrow-thin-right"></span>');

      $('aside').removeClass('moveOut');
      $('.slidePopOut').removeClass('moveIn');
      $('.map article, .timeContainer').removeClass('widthL');
    }, 
    function() {
      $('aside').addClass('moveOut');
      $('.slidePopOut').addClass('moveIn');
      $('.map article, .timeContainer').addClass('widthL');
      $('#toggle').html('<span aria-hidden="true" class="icon-arrow-thin-left"></span> Refine');

      $('aside').removeClass('moveIn');
      $('.slidePopOut').removeClass('moveOut');
      $('.map article, .timeContainer').removeClass('widthS');
    }
  );

  $('#toggle.Marticle').click( function() {
      $('aside').addClass('moveIn');
      $('.map article, .timeContainer').addClass('moveOut');
      $('#toggle.Marticle').hide();
      $('#toggle.Maside').show();

      $('aside').removeClass('moveOut');
      $('.map article, .timeContainer').removeClass('moveIn');
  });

  $('#toggle.Maside').click( function() {
      $('aside').addClass('moveOut');
      $('.map article, .timeContainer').addClass('moveIn');
      $('#toggle.Marticle').show();
      $('#toggle.Maside').hide();

      $('aside').removeClass('moveIn');
      $('.map article, .timeContainer').removeClass('moveOut');
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
      $(this).html('<span aria-hidden="true" class="icon-arrow-thin-up"></span>');
    },
    function(){
      $('.topNav, .MainNav').slideUp();
      $(this).html('<span aria-hidden="true" class="icon-arrow-thin-down"></span>');
    }
  );

  /// REFRESH once the width is 680
  var ww = $(window).width();
  var limit = 680;

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
  $(".inline").colorbox({inline:true, width:"50%"});

  $('.pop-open').click(function() {
    $('.pop-columns.country').fadeOut(function() {
      $('.pop-columns.states').fadeIn();
    });
  });


  $('.scrubber').slider();


       
});
