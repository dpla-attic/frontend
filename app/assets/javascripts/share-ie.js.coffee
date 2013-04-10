$(document).ready ->
  if($.browser.msie)
    $('.shareSave').on 'hover', 'iframe', ->
      $(this).parents('.btn').toggleClass('hover-ie');
