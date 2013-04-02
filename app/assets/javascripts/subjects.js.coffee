$(document).ready ->
  $('#content.subjects .tabs a').click ->
    link = $(this)
    li   = link.parents('li')
    ul   = li.parent('ul.tabs')
    is_active = li.hasClass('active')
    unless is_active
      $('#content').find('.viewport').hide()
      related_tab = link.data('viewport')
      $("##{ related_tab }").show()
      ul.find('li').removeClass('active')
      li.addClass('active')
      $.colorbox.resize({heigth: $('#cboxContent').outerHeight()})
    false