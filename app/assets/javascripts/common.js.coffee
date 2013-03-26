jQuery ->
  if $('input#q').val().length == 0
    $('input#q').focus()

  $('#more_subjects, #more_locations, #more_types, #more_languages').on 'click', '.pagination a', ->
    parent = $(this).parents('.popBar').parent()
    current = parent.find '.pagination .current'
    unless current[0] == $(this)[0]
      current_page = current.data 'page'
      parent.find('.pop-columns[data-page='+current_page+']').hide()
      page = $(this).data 'page'
      parent.find('.pop-columns[data-page='+page+']').show()
      current.replaceWith "<a data-page="+current_page+" href=\"#\">"+current_page+"</a>"
      $(this).replaceWith "<span data-page="+page+" class=\"current\">"+page+"</span>"
      $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})
      false

  $('#more_locations .tabs a').click ->
    link = $(this)
    li   = link.parents('li')
    ul   = li.parent('ul.tabs')
    is_active = li.hasClass('active')
    unless is_active
      $('#more_locations').find('.viewport').hide()
      related_tab = link.data('viewport')
      $("##{ related_tab }").show()
      ul.find('li').removeClass('active')
      li.addClass('active')
      $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})
    false

  $('#countries .pop-open').click ->
    $('#countries').fadeOut ->
      $('#states').fadeIn()
      $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})

  $('#states .breadCrumbs li.countries a').click ->
    $('#states').fadeOut ->
      $('#countries').fadeIn()
      $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})
    false