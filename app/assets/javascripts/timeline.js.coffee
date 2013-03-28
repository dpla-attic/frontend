jQuery ->
  container = $('.timelineContainer')
  current_sheet = 2 # first page is 1 (not 0), as in CSS
  total_sheets = 5

  fetched_page = 1
  infinite_scroll_in_progress = false


  render_docs = (result)->
    html = ''
    if $.isPlainObject(result) and $.isArray(result.docs)
      $.each result.docs, (i, doc)->
        type  = "<h6>#{ doc['aggregatedCHO.type'] }</h6>"
        title = "<a href=\"/item/#{ doc['id'] }\">#{ doc['aggregatedCHO.title'] }</a>"
        creator = "<p><span>#{ doc['aggregatedCHO.creator'] }</span></p>"
        description = "<p>#{ doc['aggregatedCHO.description'] || '' }</p>"
        source_link =
          if !! doc['isShownAt.@id']
            """
            <a href="#{ doc['isShownAt.@id'] }" class="ViewObject" target="_blank">
              View Object
              <span class="icon-view-object" aria-hidden="true"></span>
            </a>
            """
          else ''
        preview =
          if !! doc['object.@id']
            "<img src=\"#{ doc['object.@id'] }\" />"
          else ''

        html +=
        """
        <section>
          <div class="sectionRight">#{ preview }</div>
          <div class="sectionLeft">
            #{ type }
            #{ title }
            #{ creator }
            #{ description }
            #{ source_link }
          </div>
        </section>
        """
    html

  render_loader = (css = {})->
    $('<img />').attr('src', '/assets/timeline-ajax-loader.gif').css(css)

  render_items_count = (count)->
    "<h2 class=\"items_count\"><span color=\"#000\">#{ count }</span> items</h2>"

  updateWindowLocation = (params = {})->
    if params.year
      $.address.parameter('year', params.year)

  # Click on graph column
  $('.graph').on 'click', 'li', (event) ->
    fetched_page = 1
    requested_year = parseInt $(this).find('h3').text()
    updateWindowLocation year: requested_year
    infinite_scroll_in_progress = false
    loader = render_loader()
    if requested_year
      el = container.find(".timeline-row:nth-child("+ current_sheet + ")")
      el.find('.year h3').text requested_year
      $.ajax
        url: api_search_path
        dataType: 'jsonp'
        cache: true
        data:
          'aggregatedCHO.date.before': requested_year
          'aggregatedCHO.date.after':  requested_year
        beforeSend: ->
          el.find('.timelineResults').html('').append loader
        success: (result) ->
          count = render_items_count result.count
          html = render_docs result
          loader.remove()
          el.find('.timelineResults').append count, html

      $('.timeContainer').removeClass('decadesView').addClass('yearsView')
      $('.Decades').hide()
      $('.timelineContainer').show()
    return false

  # Previous / next page
  fetchPage = (year, page) ->
    fetched_page = 1
    loader = render_loader()
    $.ajax
      url: api_search_path
      dataType: 'jsonp'
      cache: true
      data:
        'aggregatedCHO.date.before': year
        'aggregatedCHO.date.after':  year
      beforeSend: ->
        $('.prev, .next').hide()
        page.find('.year h3').text year
        page.find('.timelineResults').html('').append loader
      success: (result) ->
        loader.remove()
        count = render_items_count result.count
        html = render_docs result
        page.find('.timelineResults').append count, html

  $('.timelineContainer').on 'click', '.timeline-row', (event) ->
    current_year = parseInt $(this).find('.year h3').text()
    page = container.find(".timeline-row:nth-child("+ current_sheet + ")")

    # If this is a last page or first page we need move
    if current_sheet >= total_sheets
      container.append(container.find('.timeline-row:first-child'))
      current_sheet = current_sheet-1
      container.animate { right: '-=100%' }, 0
    else if current_sheet <= 1
      container.prepend(container.find('.timeline-row:last-child'))
      current_sheet = current_sheet+1
      container.animate { right: '+=100%' }, 0

    if event.target.className == 'next'
      year = current_year+1
      _page = page.next()
      fetchPage(year, _page) unless _page.find('.year h3').text() == year.toString()
      container.animate { right: '+=100%' }, 500, ->
        $('.prev, .next').show()
      current_sheet = current_sheet + 1

    else if event.target.className == 'prev'
      year = current_year-1
      _page = page.prev()
      fetchPage(year, _page) unless _page.find('.year h3').text() == year.toString()
      container.animate { right: '-=100%' }, 500, ->
        $('.prev, .next').show()
      current_sheet = current_sheet - 1

    updateWindowLocation year: year

  # Infinite scroll
  $('.timelineResults').on 'scroll', (event) ->
    holder = $(this)
    current_year = $(this).parents('.timeline-row').find('.year h3').text()
    if ! infinite_scroll_in_progress && $(this).scrollTop() > this.scrollHeight - $(this).height() - 500
      ajax_loader = render_loader({'margin-top': '20px'})
      $.ajax
        url: api_search_path
        dataType: 'jsonp'
        cache: true
        data:
          'aggregatedCHO.date.before': current_year
          'aggregatedCHO.date.after':  current_year
          'page': ++fetched_page
        beforeSend: ->
          infinite_scroll_in_progress = true
          holder.append ajax_loader
        success: (result) ->
          ajax_loader.remove()
          html = render_docs result
          holder.append html
        complete: ->
          infinite_scroll_in_progress = false

  if year = $.address.parameter('year')
    li = $("li[data-year=\'#{ year }\']")
    li.click()