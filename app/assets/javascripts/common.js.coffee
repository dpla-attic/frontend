window.image_loading_error = (image)->
  setTimeout ->
    if default_src = $(image).data('default-src')
      $(image).attr('src', default_src);
    else
      $(image).remove()
  , 0

jQuery ->
  if $('input#searchField').val().length == 0
    $('input#searchField').focus()

  $('#more_subjects, #more_locations, #more_types, #more_providers, #more_partners, #more_languages, #more_exhibitions').on 'click', '.pagination a', ->
    parent = $(this).parents('.popBar').parent()
    current = parent.find '.pagination .current'
    unless current.text() == $(this).text()
      current_page = current.data 'page'
      parent.find('.pop-columns[data-page='+current_page+']').fadeOut ->
        page = $(this).data 'page'
        parent.find('.pop-columns[data-page='+page+']').fadeIn()

      container = $(this).parents('.popBar').parent()
      container.find('.pagination span.current')
        .replaceWith "<a data-page="+current_page+" href=\"#\">"+current_page+"</a>"
      container.find(".pagination a[data-page=#{ page }]")
        .replaceWith "<span data-page="+page+" class=\"current\">"+page+"</span>"
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
    false

  $('#countries .pop-open').click ->
    $('#countries').fadeOut ->
      $('#states').fadeIn()

  $('#states .breadCrumbs li.countries a').click ->
    $('#states').fadeOut ->
      $('#countries').fadeIn()
    false

  if window.twitter_account
    $('.twitter #tweets').tweet
      username: window.twitter_account
      count: 2

  if window.wordpress_url && $('#wp_news_feed').length > 0
    news_container = $('#wp_news_feed ul')
    $.ajax
      url: window.wordpress_url
      dataType: 'jsonp'
      cache: true
      jsonpCallback: 'receive_wordpress_news'
      data:
        json: 1
        count: 2
      success: (data)->
        if data.posts
          $.each data.posts, (i,post)->
            post_date = $.datepicker.parseDate('yy-mm-dd', post.date)
            news_container.append """
            <li>
              <a href="#{ post.url }">#{ post.title }</a>
              <p><span>#{ $.datepicker.formatDate('M d', post_date) }</span></p>
            </li>
            """

  colorbox_options = 
    initialWidth: '558px'
    width:'100%'
    maxWidth: '600px'
    transition: 'none'
    close: '&times;'
    reposition: false

  $('.login').colorbox _.extend(colorbox_options, initialHeight: '289px')

  $('.signUp').colorbox _.extend(colorbox_options, initialHeight: '562px')
