jQuery ->
  container = $('.timelineContainer')
  current_sheet = 2 # first page is 1 (not 0), as in CSS
  total_sheets = 5

  fetched_page = 1
  infinite_scroll_in_progress = false

  $('article.timeline').on "timeline:decades_tab_activated", (e, eventInfo) ->
    updateLinks()

  updateLinks = () ->
    $('.module.yellow li a, .pop-columns li a, .refine li a, .refineResult a').each (index, el) ->
      url = el.href
      if url.indexOf("#") >= 0
        url = url.substring(0, url.indexOf('#'));
      if ($('.yearsView').length)
        hash = location.hash.substring(location.hash.indexOf("#/?") + 3)
        if (hash)
          el.href = url + "#/?" + hash
      else
        el.href = url

  updateLinks()


  render_docs = (result)->
    html = ''

    bumped_item_id = $.address.parameter('item_id')
    if $.isPlainObject(result) and $.isArray(result.docs)
      $.each result.docs, (i, doc)->
        if bumped_item_id && (doc['id'] == bumped_item_id)
          return
        item_href = "/item/#{ doc['id'] }?back_uri=#{ encodeURIComponent(window.location.href) }"
        type  = "<h6>#{ doc['sourceResource.type'] || '' }</h6>"
        title = "<a href=\"#{ item_href }\">#{ doc['sourceResource.title'] || doc['id'] }</a>"
        creator = "<p><span>#{ doc['sourceResource.creator'] || '' }</span></p>"
        description = "<p>#{ doc['sourceResource.description'] || '' }</p>"
        source_link =
          if !! doc['isShownAt']
            """
            <a href="#{ doc['isShownAt'] }" class="ViewObject" target="_blank">
              View Object
              <span class="icon-view-object" aria-hidden="true"></span>
            </a>
            """
          else ''
        preview =
          if !! doc['object']
            "<img src=\"#{ doc['object'] }\" />"
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
          'sourceResource.date.before': requested_year
          'sourceResource.date.after':  requested_year
        beforeSend: ->
          el.find('.timelineResults').html('').append loader
        success: (result) ->
          count = render_items_count result.count
          html = render_docs result
          loader.remove()
          el.find('.timelineResults').append count, html
          $('article.timeline').trigger('timeline:year_loaded')

      $('.timeContainer').removeClass('decadesView').addClass('yearsView')
      $('.Decades').hide()
      $('.timelineContainer').show()
      updateLinks()
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
        'sourceResource.date.before': year
        'sourceResource.date.after':  year
      beforeSend: ->
        $('.prev, .next').hide()
        page.find('.year h3').text year
        page.find('.timelineResults').html('').append loader
      success: (result) ->
        loader.remove()
        count = render_items_count result.count
        html = render_docs result
        page.find('.timelineResults').append count, html
        updateLinks()

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
      $('.scrubber').slider('value', $('.scrubber').slider('value') + 98.039257);
      current_sheet = current_sheet + 1

    else if event.target.className == 'prev'
      year = current_year-1
      _page = page.prev()
      fetchPage(year, _page) unless _page.find('.year h3').text() == year.toString()
      container.animate { right: '-=100%' }, 500, ->
        $('.prev, .next').show()
      $('.scrubber').slider('value', $('.scrubber').slider('value') - 98.039257);
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
          'sourceResource.date.before': current_year
          'sourceResource.date.after':  current_year
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

    if item_id = $.address.parameter('item_id')
      $('article.timeline').one 'timeline:year_loaded', ->
        $.address.parameter('item_id', null)
        el = container.find(".timeline-row:nth-child("+ current_sheet + ")")
        $.ajax
          url: api_item_path.replace '%', item_id
          dataType: 'jsonp'
          cache: true
          success: (result) ->
            el.find('section').css({opacity: 0.25})
            el.find('.timelineResults').one 'scroll', ->
              el.find('section').css({opacity: 1})
            el.find('h2').after(render_docs result)