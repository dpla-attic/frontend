jQuery ->
  $('#more_subjects .pagination').on 'click', 'a', ->
    parent = $(this).parents '#more_subjects'
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