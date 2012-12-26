;(function ($, window, undefined) {
  'use strict';

  var $doc = $(document),
      Modernizr = window.Modernizr;

  $(document).ready(function() {
    $.fn.foundationAlerts           ? $doc.foundationAlerts() : null;
    $.fn.foundationButtons          ? $doc.foundationButtons() : null;
    $.fn.foundationAccordion        ? $doc.foundationAccordion() : null;
    $.fn.foundationNavigation       ? $doc.foundationNavigation() : null;
    $.fn.foundationTopBar           ? $doc.foundationTopBar() : null;
    $.fn.foundationCustomForms      ? $doc.foundationCustomForms() : null;
    $.fn.foundationMediaQueryViewer ? $doc.foundationMediaQueryViewer() : null;
    $.fn.foundationTabs             ? $doc.foundationTabs({callback : $.foundation.customForms.appendCustomMarkup}) : null;
    $.fn.foundationTooltips         ? $doc.foundationTooltips() : null;
    $.fn.foundationMagellan         ? $doc.foundationMagellan() : null;
    $.fn.foundationClearing         ? $doc.foundationClearing() : null;

    $.fn.placeholder                ? $('input, textarea').placeholder() : null;


    // Custom scripts
    $('.pin.six a').click(function() {
      $('.popup, .pin.six a').addClass('on');
      return false;
    });
    $('.popup .close').click(function() {
      $('.popup, .pin.six a').removeClass('on');
      return false;
    });
    $('#refine-subjects-modal .button').click(function() {
      $('#refine-subjects-modal').trigger('reveal:close');
      return false;
    });
    $('#refine-location-modal .button').click(function() {
      $('#refine-location-modal').trigger('reveal:close');
      return false;
    });
    $('#featuredContent').orbit({ fluid: '16x6' });

    $('#refine-location-modal .states, #refine-location-modal .cities').hide();

    $('#refine-location-modal .countries a.drill').click(function() {
      $('#refine-location-modal .countries').fadeOut(function() {
        $('#refine-location-modal .states').fadeIn();
      });
      return false;
    });
    $('#refine-location-modal .states a.drill').click(function() {
      $('#refine-location-modal .states').fadeOut(function() {
        $('#refine-location-modal .cities').fadeIn();
      });
      return false;
    });

  });

  // UNCOMMENT THE LINE YOU WANT BELOW IF YOU WANT IE8 SUPPORT AND ARE USING .block-grids
  // $('.block-grid.two-up>li:nth-child(2n+1)').css({clear: 'both'});
  // $('.block-grid.three-up>li:nth-child(3n+1)').css({clear: 'both'});
  // $('.block-grid.four-up>li:nth-child(4n+1)').css({clear: 'both'});
  // $('.block-grid.five-up>li:nth-child(5n+1)').css({clear: 'both'});

  // Hide address bar on mobile devices (except if #hash present, so we don't mess up deep linking).
  if (Modernizr.touch && !window.location.hash) {
    $(window).load(function () {
      setTimeout(function () {
        window.scrollTo(0, 1);
      }, 0);
    });
  }

})(jQuery, this);
