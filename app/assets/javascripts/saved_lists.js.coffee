$(document).ready ->
  if $('.saved_lists-controller').length > 0
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
    $('.remove_items').click ->
      form = $(this).parents('.rightSide').find('form')
      affected = form.find('.checkbox.item:checked')
      return false unless affected.length
      return false unless confirm 'Are you sure?'

      $.ajax
        type: 'DELETE',
        url: '/saved/lists/delete_positions'
        data:
          positions: affected.map (i,checkbox)->
              $(checkbox).data()
            .toArray()
        complete: ->
          window.location.href = window.location.href

      false

    # Copy items
    # POST /saved/lists/copy_positions
    $('#copy_items_to a').click ->
      list = $(this).data 'list'
      form = $(this).parents('.rightSide').find('form')
      affected = form.find('.checkbox.item:checked')
      return false unless list
      return false unless affected.length

      $.ajax
        type: 'POST',
        url: '/saved/lists/copy_positions'
        data:
          list: list,
          positions: affected.map (i,checkbox)->
              $(checkbox).data()
            .toArray()
        complete: ->
          window.location.href = window.location.href

      return false

    # Move items
    # POST /saved/lists/move_positions
    $('#move_items_to a').click ->
      list = $(this).data 'list'
      form = $(this).parents('.rightSide').find('form')
      affected = form.find('.checkbox.item:checked')
      return false unless list
      return false unless affected.length

      $.ajax
        type: 'POST',
        url: '/saved/lists/move_positions'
        data:
          list: list,
          positions: affected.map (i,checkbox)->
              $(checkbox).data()
            .toArray()
        complete: ->
          window.location.href = window.location.href

      return false

    # Reorder positions
    # POST /saved/lists/reorder_positions
    $('.reorder_items').click ->
      form = $(this).parents('.rightSide').find('form')
      affected = $.each form.find('.position.item'), (i,input)->
        $(input).val('') if isNaN Math.abs(parseInt($(input).val(), 10))
      return false unless affected.length

      $.ajax
        type: 'POST',
        url: '/saved/lists/reorder_positions'
        data:
          positions: affected.map (i,input)->
              data = $(input).data()
              data.value = (Math.abs(parseInt($(input).val(), 10)) || 0)
              data
            .toArray()
        complete: ->
          window.location.href = window.location.href

      return false

    # Switch status
    # POST /saved/lists/switch_status
    $('.statusLink').click ->
      that = $(this)
      list = that.data 'list'
      return false unless list

      $.ajax
        type: 'POST',
        url: '/saved/lists/switch_status'
        data:
          list: list
        complete: ->
          if that.hasClass('icon-lock')
            that.removeClass('icon-lock').addClass('icon-unlock')
          else
            that.removeClass('icon-unlock').addClass('icon-lock')
          if ($(".active." + list).length > 0) #should update right side
            el = $('#selectedListStatus span');
            if el.hasClass('icon-lock')
              el.removeClass('icon-lock').addClass('icon-unlock')
            else
              el.removeClass('icon-unlock').addClass('icon-lock')


      return false

