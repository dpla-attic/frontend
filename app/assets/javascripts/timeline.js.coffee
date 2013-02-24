jQuery ->
  container = $('.timelineContainer')
  current_page = 2 # first page is 1 (not 0), as in CSS
  total_pages = 5

  $('.graph').on 'click', 'li', (event) ->
    requested_year = parseInt $(this).find('h3').text()
    if requested_year
      $.post("/timeline/items_by_year", year: requested_year).done (html) ->
        el = container.find(".timeline-row:nth-child("+ current_page + ")")
        el.find('.year h3').text requested_year
        el.find('.timelineResults').html html
        $('.timeContainer').removeClass('decadesView').addClass('yearsView')
        $('.Decades').hide()
        $('.timelineContainer').show()
    return false

  $('.timelineContainer').on 'click', '.timeline-row', (event) ->
    current_year = parseInt $(this).find('.year h3').text()
    if event.target.className == 'next'
      year = current_year + 1
      page = container.find(".timeline-row:nth-child("+ current_page + ")")

      # If this is a last page or first page we need move
      if current_page >= total_pages
        container.append(container.find('.timeline-row:first-child'))
        current_page = current_page-1
        container.animate { right: '-=100%' }, 0
      
      $('.prev, .next').hide()
      $.post("/timeline/items_by_year", year: year).done (html) ->
        page.next().find('.timelineResults').html html
        page.next().find('.year h3').text year
        container.animate { right: '+=100%' }, 500, -> 
          $('.prev, .next').show()
        current_page = current_page + 1

    else if event.target.className == 'prev'
      year = current_year - 1
      page = container.find(".timeline-row:nth-child("+ current_page + ")")
      
      if current_page <= 1
        container.prepend(container.find('.timeline-row:last-child'))
        current_page = current_page+1
        container.animate { right: '+=100%' }, 0
  
      $('.prev, .next').hide()
      $.post("/timeline/items_by_year", year: year).done (html) ->
        page.prev().find('.timelineResults').html html
        page.prev().find('.year h3').text year
        container.animate { right: '-=100%' }, 500, -> 
          $('.prev, .next').show()
        current_page = current_page - 1
        
  $('.timelineResults').on 'scroll', (event) ->
    $holder = $(this)
    url = $(this).find('.pagination a').attr('href')
    if url && $(this).scrollTop() > this.scrollHeight - $(this).height() - 500
      $holder.find('.pagination').text("Fetching more items...")
      $.post(url).done (html) ->
        $holder.find('.pagination').remove()
        $holder.append html
