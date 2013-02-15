$(document).ready ->
  if $('.search-controller').length > 0

    $('select#page_size, select#sort_by').on 'change', ->
      window.location.href = $(this).val()

    $('#more_subjects .pagination a').on 'click', ->
      parent = $(this).parents '#more_subjects'
      current = parent.find 'a.current'
      unless current[0] == $(this)[0]
        current_page = current.data 'page'
        parent.find('.pop-columns[data-page='+current_page+']').hide()
        page = $(this).data 'page'
        parent.find('.pop-columns[data-page='+page+']').show()
        current.removeClass 'current'
        $(this).addClass 'current'
        $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})
        false
