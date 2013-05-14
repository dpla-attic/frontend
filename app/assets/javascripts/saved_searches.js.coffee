$(document).ready ->
  # Retrieving count for saved searches
  href = window.location.href
  sort_option = 'ASC'
  if href.indexOf("sort=DESC") > 0
    $('#termSortLink').find('span').addClass('icon-arrow-down');
  else if href.indexOf("sort=ASC") > 0
    sort_option = 'DESC'
    $('#termSortLink').find('span').addClass('icon-arrow-up');

  $('#termSortLink').attr('href', '?sort=' + sort_option)
  $('.count').each ->
    that = $(this)
    $.ajax
      url: $(this).data 'apiUrl'
      dataType: 'jsonp'
      cache: true
      success: (data)->
        that.text data.count

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
  # DELETE /saved/searches/destroy_bulk
  $('#remove_searches').click ->
    form = $(this).parents('.savedItems').find('form')
    affected = form.find('.checkbox.item:checked')
    return false unless affected.length
    return false unless confirm 'Are you sure?'

    $.ajax
      type: 'POST',
      url: '/saved/searches/destroy_bulk'
      data:
        ids: affected.map (i,checkbox)->
            $(checkbox).data()
          .toArray()
      complete: ->
        window.location.href = window.location.href

    false
