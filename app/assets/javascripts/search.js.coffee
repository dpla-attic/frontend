$ ->
  if $('.search-controller').length > 0
    $('select#page_size, select#sort_by').on 'change', ->
      window.location.href = $(this).val()