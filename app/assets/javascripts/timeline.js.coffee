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

  fetchPage = (year, page) ->
    if page > current_page
      updated_page = container.find(".timeline-row:nth-child("+ current_page + ")")
    $.post("/timeline/items_by_year", year: year).done (html) ->
      page.next().find('.timelineResults').replaceWith html
      page.next().find('.year h3').text year

      container.animate { right: '+=100%' }, 500, -> 
        $('.prev, .next').show()
      $('.timelineContainer').append $('.timelineContainer .timeline-row:nth-child(1)')
      $('.timelineContainer').animate { right: '-=100%' }, 0

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

  # page = 0;
  # $('.timelineContainer').on 'scroll', '.timelineResults', (event) ->
  #   alert "scroll"
  #   if $(this).scrollTop() > $(this).height() - $(this).scrollHeight() - 50
  #     current_year = parseInt($(this).parent().parent().find('.year h3').text())
  #     $.post("/timeline/items_by_year", year: current_year, page: page++).done (html) ->
  #       $(this).append html
  #$('.timelineContainer .timeline-row:nth-child(2) .timelineResults').scroll

#   $(window).scroll ->
#     url = $('.pagination .next_page').attr('href')
#     if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
#       $('.pagination').text("Fetching more items...")
#       $.getScript(url)
#   $(window).scroll()