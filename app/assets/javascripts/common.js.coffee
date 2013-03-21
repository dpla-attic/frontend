jQuery ->
  $('#more_subjects, #more_locations, #more_types, #more_languages').on 'click', '.pagination a', ->
    parent = $(this).parents '.inline_content'
    current = parent.find '.current'
    unless current[0] == $(this)[0]
      current_page = current.data 'page'
      parent.find('.pop-columns[data-page='+current_page+']').hide()
      page = $(this).data 'page'
      parent.find('.pop-columns[data-page='+page+']').show()
      current.replaceWith "<a data-page="+current_page+" href=\"#\">"+current_page+"</a>"
      $(this).replaceWith "<span data-page="+page+" class=\"current\">"+page+"</span>"
      $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})
      false

  # Temporary solution
  $('#more_subjects .pop-columns li').on 'click', 'a', ->
    window.location.href = $(this).attr('href')