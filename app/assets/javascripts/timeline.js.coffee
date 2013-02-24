jQuery ->

  $('.graph li').on 'click', ->
    requested_year = $(this).find('h3').text()
    if requested_year
      $.post("/timeline/items_by_year", year: requested_year).done (html) ->
        $('.timelineContainer .timeline-row:nth-child(2)').replaceWith html
        $('.timeContainer').removeClass('decadesView').addClass('yearsView')
        $('.Decades').hide()
        $('.timelineContainer').show()
    return false

  $('.timelineContainer').on 'click', '.timeline-row .next', (event) ->
    current_year = parseInt($(this).parent().find('.year h3').text())
    $('.prev, .next').hide()
    $.post("/timeline/items_by_year", year: current_year+1).done (html) ->
      $('.timelineContainer .timeline-row:nth-child(3)').replaceWith html

      $('.timelineContainer').animate { right: '+=100%' }, 500, -> 
        $('.prev, .next').show()
      $('.timelineContainer').append $('.timelineContainer .timeline-row:nth-child(1)')
      $('.timelineContainer').animate { right: '-=100%' }, 0

  $('.timelineContainer').on 'click', '.timeline-row .prev', (event) ->
    current_year = parseInt($(this).parent().find('.year h3').text())
    $('.prev, .next').hide()
    $.post("/timeline/items_by_year", year: current_year-1).done (html) ->
      $('.timelineContainer .timeline-row:nth-child(1)').replaceWith html

      $('.timelineContainer').animate { right: '-=100%' }, 500, -> 
        $('.prev, .next').show()
      $('.timelineContainer').prepend $('.timelineContainer .timeline-row:nth-child(3)')
      $('.timelineContainer').animate { right: '+=100%'}, 0

  page = 0;
  $('.timelineContainer').on 'scroll', '.timelineResults', (event) ->
    alert "scroll"
    if $(this).scrollTop() > $(this).height() - $(this).scrollHeight() - 50
      current_year = parseInt($(this).parent().parent().find('.year h3').text())
      $.post("/timeline/items_by_year", year: current_year, page: page++).done (html) ->
        $(this).append html
  #$('.timelineContainer .timeline-row:nth-child(2) .timelineResults').scroll

#   $(window).scroll ->
#     url = $('.pagination .next_page').attr('href')
#     if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
#       $('.pagination').text("Fetching more items...")
#       $.getScript(url)
#   $(window).scroll()