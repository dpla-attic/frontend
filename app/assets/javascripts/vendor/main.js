$(window).load(function() {

  ///// Social media buttons

if ($('.shareSave').length) {
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
}


	$('.homeslide').flexslider({
	    animation: "slide",
	    pauseOnHover: true,
      prevText: '<span class="icon-arrow-left" aria-hidden="true"></span>',
      nextText: '<span class="icon-arrow-right" aria-hidden="true"></span>'
	});

	$('.moreInfo').mouseover(function () {
      $(this).addClass('hover');
      $('.flex-direction-nav a').addClass('hover');
	    $('.flex-active-slide .slideOverlay').addClass('on');
	    $('.flex-active-slide .slideText').addClass('on');
	});

	$('.forgotPassword').click(function() {
    $(this).hide();
		$('.forgotSlide').slideDown();
		$('#cboxLoadedContent, #cboxWrapper, #colorbox, #cboxContent').animate({height: '430px'});
		return false;
	});

	$('#cboxOverlay, #cboxClose').click(function() {
		$('.forgotSlide').slideUp();
		$('#cboxLoadedContent, #cboxWrapper, #colorbox, #cboxContent').animate({height: '320px'});
		return false;
	});

  $('.moreInfo').toggle(function() {
      $(this).addClass('hover');
      $('.flex-direction-nav a').addClass('hover');
      $('.flex-active-slide .slideOverlay').addClass('on');
      $('.flex-active-slide .slideText').addClass('on');
    },
    function() {
      $(this).removeClass('hover');
      $('.flex-direction-nav a').removeClass('hover');
      $('.flex-active-slide .slideOverlay').removeClass('on');
      $('.flex-active-slide .slideText').removeClass('on');
    }
  );

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

  // $('.pop-open').click(function() {
  //   $('.breadCrumbs li').removeClass('current');
  //   $(this).next('a').clone().appendTo('.breadCrumbs ul').wrap('<li class="current"></li>');
  // });

  $('.collections .pop-columns a').click(function() {
    $('.breadCrumbs li').removeClass('current');
    $(this).clone().appendTo('.breadCrumbs ul').wrap('<li class="current"></li>');
  });

  $('.head').toggle(function() {
      $(this).next().slideDown();
      $(this).addClass('close');
      $(this).children('span').addClass('icon-arrow-up');
      $(this).children('span').removeClass('icon-arrow-down');
    },
    function() {
      $(this).next().slideUp();
      $(this).removeClass('close');
      $(this).children('span').addClass('icon-arrow-down');
      $(this).children('span').removeClass('icon-arrow-up');
    }
  );

  ///// Search Field Open + Close on Phones
  var boxHit = false;
  var fieldHit = true;
  var boxTimeout;
  var fieldTimeout;

  $('.search-btn').click(function() {
    $('.searchViews, .search-btn').addClass('off');
	$('.searchRowRight form input[type="submit"]').hide();
    $('.searchRowRight form').show().animate({width: '98%'}, 500, function() {
	  $('.searchRowRight form input[type="submit"]').fadeIn(200);
	});
	$('.searchRowRight form input[type="text"]').focus();
    return false;
  });

  $('.searchRowRight form input[type="checkbox"]').click(function() {
	boxHit = true;
	fieldHit = false;
	$(this).focus();
	clearTimeout(boxTimeout);
	clearTimeout(fieldTimeout);
  });

  $('.searchRowRight form input[type="text"]').focus(function() {
	fieldHit = true;
	boxHit = false;
	clearTimeout(boxTimeout);
	clearTimeout(fieldTimeout);
  });

  $('.searchRowRight form input[type="checkbox"]').blur(function() {
	boxTimeout = setTimeout(function(){
	  if (fieldHit == false) { searchHide(); }
	}, 500);
  });

  $('.searchRowRight form input[type="text"]').blur(function() {
	fieldTimeout = setTimeout(function(){
	  if (boxHit == false) { searchHide(); }
	}, 500);
  });

  function searchHide() {
  	$('.search-btn, .searchViews').removeClass('off');
	$('.searchRowRight form').attr('style', '');
  }

  ///// REFINE SIDEBAR TOGGLE: DESKTOP AND TABLET
  $('.timeline .toggle, .map .toggle').click(function() {
    if ($('aside').is(':visible')) {
      $('aside').addClass('moveOut');
      $('.slidePopOut').addClass('moveIn');
      $('.map article, .timeContainer').addClass('widthL');
      $('.toggle').html('Show <span aria-hidden="true" class="icon-arrow-thin-right"></span>');

      $('aside').removeClass('moveIn');
      $('.slidePopOut').removeClass('moveOut');
      $('.map article, .timeContainer').removeClass('widthS');
    }
    else {
      $('aside').addClass('moveIn');
      $('.slidePopOut').addClass('moveOut');
      $('.map article, .timeContainer').addClass('widthS');
      $('.toggle').html('<span aria-hidden="true" class="icon-arrow-thin-left"></span> Hide');

      $('aside').removeClass('moveOut');
      $('.slidePopOut').removeClass('moveIn');
      $('.map article, .timeContainer').removeClass('widthL');
    }
  });

  ///// REFINE SIDEBAR TOGGLE: PHONE
  $('.toggle.Marticle').toggle( function() {
      $('aside').addClass('moveIn');
      $('.map article, .timeContainer, .slidePopOut').addClass('moveOut');
      $('.toggle.Marticle').html('<span aria-hidden="true" class="icon-arrow-thin-left"></span> Hide');

      $('aside').removeClass('moveOut');
      $('.map article, .timeContainer, .slidePopOut').removeClass('moveIn');
    },
    function() {
      $('aside').addClass('moveOut');
      $('.map article, .timeContainer, .slidePopOut').addClass('moveIn');
      $('.toggle.Marticle').html('Show <span aria-hidden="true" class="icon-arrow-thin-right"></span>');

      $('aside').removeClass('moveIn');
      $('.map article, .timeContainer, .slidePopOut').removeClass('moveOut');
    }
  );

  $('.mapContainer').click(function() {
    $('.mobile-hover').hide();
    $('.map iframe').animate({ height: '300px' }, 'slow');
  });

  $('.open').click(function() {
    if ($(this).next('.slidingDiv').is(':visible')) {
      $(this).next('.slidingDiv').slideUp();
      $(this).children('span').addClass('icon-arrow-down');
      $(this).children('span').removeClass('icon-arrow-up');
    }
    else {
      $(this).next('.slidingDiv').slideDown();
      $(this).children('span').addClass('icon-arrow-up');
      $(this).children('span').removeClass('icon-arrow-down');
    }
  });

/*
  $('.pop-columns li').toggle(
    function(){
      $(this).children('ul').slideDown();
    },
    function(){
      $(this).children('ul').slideUp();
    }
  );
*/

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

  $('#inline_content .tabs a, .shareSave .btn.share, .resultsBar .btn').click(function() {
    return false;
  });

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
  $('.inline').colorbox({
    inline:true,
    width:'100%',
    maxWidth: '1000px',
    transition: 'none',
    close: '&times;',
    reposition: false
  });

  // $('.pop-open').click(function() {
  //   $('.pop-columns.country').fadeOut(function() {
  //     $('.pop-columns.states').fadeIn();
  //   });
  // });


  //PROFILE: Saved Searches Column Sort
  $('.sort').click(function() {
    if ($(this).hasClass('active')) {
      if ($(this).find('span').hasClass('icon-arrow-up')) {
        $(this).find('span').removeClass('icon-arrow-up').addClass('icon-arrow-down');
      } else {
        $(this).find('span').removeClass('icon-arrow-down').addClass('icon-arrow-up');
      }
    } else {
      $('.sort').removeClass('active');
      $('.sort').find('span').removeClass('icon-arrow-up icon-arrow-down');
      $(this).addClass('active');
      $(this).find('span').addClass('icon-arrow-down');
    }
    return false;
  });

  //ITEM DETAIL: toggle description length
  $('.desc-short .desc-toggle').click(function() {
    $('.desc-short').hide();
    $('.desc-long').slideDown();
    return false;
  });
  $('.desc-long .desc-toggle').click(function() {
    $('.desc-long').slideUp(function() {
      $('.desc-short').fadeIn('fast');
    });
    return false;
  });

  // Fix subpixel rounding on timeline for proper alignment of years and bars. Delete when full browser support exists.
  if ($('.timeline').length) {
	var barsCount = 0;
	$('.bars li').each(function() {
	  $(this).css({'margin-right': '-100%','margin-left': (0.906343*barsCount) + '%'});
	  barsCount = barsCount + 1;
	});
	var graphCount = 0;
	$('.graph li').each(function() {
	  $(this).css({'margin-right': '-100%','margin-left': (0.098038*graphCount) + '%'});
	  graphCount = graphCount + 1;
	});
	var decadesCount = 0;
	$('.DecadesDates li').each(function() {
	  $(this).css({'margin-right': '-100%','margin-left': (0.980392*decadesCount - 0.47) + '%'});
	  decadesCount = decadesCount + 1;
	});
  }

  ////////////IE8 TO FIX PLACE HOLDER
  if (!Modernizr.input.placeholder) {
    $('[placeholder]').focus(function() {
      var input = $(this);
        if (input.val() == input.attr('placeholder')) {
            input.val('');
            input.removeClass('placeholder');
          }
      }).blur(function() {
        var input = $(this);
          if (input.val() == '' || input.val() == input.attr('placeholder')) {
           input.addClass('placeholder');
           input.val(input.attr('placeholder'));
         }
      }).blur();

      $('[placeholder]').parents('form').submit(function() {
        $(this).find('[placeholder]').each(function() {
          var input = $(this);
          if (input.val() == input.attr('placeholder')) {
            input.val('');
        }
      })
    });
  }

});
