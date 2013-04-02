$(document).ready ->
   # Select all items checkbox
   $('.checkbox.select-all').click ->
     checked = $(this).attr 'checked'
     form = $(this).parents 'form'
     affected = form.find('.checkbox.item')
     if checked
       affected.attr 'checked', 'checked'
     else
       affected.removeAttr 'checked'

    # Remove items
    # DELETE /saved/lists/delete_positions
    $('#remove_items').click ->
      form = $(this).parents('.savedItems').find('form')
      affected = form.find('.checkbox.item:checked')
      return false unless affected.length
      return false unless confirm 'Are you sure?'

      $.ajax
        type: 'POST',
        url: '/saved/searches/destroy_bulk'
        data:
          positions: affected.map (i,checkbox)->
              $(checkbox).data()
            .toArray()
        complete: ->
          window.location.href = window.location.href

      false
