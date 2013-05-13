class DPLA.Models.Timeline extends Backbone.Model
  defaults:
    currentSheet: 1 # By design
    totalSheets:  5 # By design
    year: 2000
    minYear: 1000
    maxYear: 2020

  initialize: (options) ->
    this.initializeDecadesView()
    this.initializeYearView()
    this.initializeDecadesPrevNext()
    this.initializeSheets()
    this.initializeYearRotator()
    this.on 'timeline:decadesView',  this.decadesView, this
    this.on 'timeline:yearView',     this.yearView,    this
    this.on 'timeline:update_graph', this.updateGraph, this

  updateGraph: (value = null) ->
    if _.isNull value
      value = $('.scrubber').slider('value')
    move = value/1000
    $(".DecadesDates, .graph").css right: move + "%"
    if value is this.get('endPoint') * 1000
      $(".Decades .next").hide()
    else if value is 0
      $(".Decades .prev").hide()
    else
      $(".Decades .prev, .Decades .next").show()

  decadesView: ->
    this.set 'mode', 'decades'
    $('.timeContainer').removeClass('yearsView').addClass('decadesView');
    $('.DecadesDates, .graph').attr('style', '');
    $('.timelineContainer').hide();
    $('.Decades').show();

    this.updateGraph()

    if this.sliderWas
      this.scrubber.$el.slider('value', this.sliderWas)

  yearView: (year, item_id) ->
    try
      this.sliderWas = this.scrubber.$el.slider('value')

    this.set 'mode', 'year'
    this.set 'year', year
    this.trigger 'timeline:update_scrubber', this
    $('.timeContainer').removeClass('decadesView').addClass('yearsView');
    $('.timelineContainer').show()
    $('.Decades').hide()


    page = this.getCurrentPage()
    if this.get('year') is this.get('maxYear')
      page.$el.find('.prev').show()
      page.$el.find('.next').hide()
    else if this.get('year') is this.get('minYear')
      page.$el.find('.prev').hide()
      page.$el.find('.next').show()
    else
      page.$el.find('.prev, .next').show()

    params = year: year
    params['item_id'] = item_id if item_id

    page.$el.find(".prev, .next").hide()
    if year is this.get('maxYear').toString()
      page.$el.find(".prev").show()
    else if year is this.get('minYear').toString()
      page.$el.find(".next").show()
    else
      page.$el.find(".prev, .next").show()

    page.render(params)

  getCurrentPage: ->
    current_sheet = timeline.get 'currentSheet'
    this.pagesPool[ current_sheet ]

  getWindowWidth: ->
    window.innerWidth || document.documentElement.clientWidth

  initializeDecadesView: ->
    this.on 'timeline:decadesView', ->
      if this.getWindowWidth() > 980
        this.set 'slideDistance', 8.341
        this.set 'endPoint', 91.659
      else
        this.set 'slideDistance', 0.667
        this.set 'endPoint', 99.333

    timeline = this
    $('.DecadesTab').on 'click', ->
      timeline.router.navigate "//"
      false

  initializeYearView: ->
    this.on 'timeline:yearView', ->
      this.set 'endPoint', 100
    timeline = this
    $('.graph li').on 'click', ->
      year = $(this).data 'year'
      timeline.router.navigate "//#{year}"
      false

  initializeDecadesPrevNext: ->
    moving = false
    timeline = this
    $('.Decades span.next, .Decades span.prev').on 'click', ->
      slideDistance = timeline.get 'slideDistance'
      endPoint = timeline.get 'endPoint'
      direction = $(this).attr('class')
      if moving is false
        moving = true
        switch direction
          when 'next'
            moveDistance = Math.abs($(".graph").offset().left + $(".graph").outerWidth() - ($("article.timeline").outerWidth() + $("article.timeline").offset().left))
            if moveDistance < $(".graph").width() * (slideDistance / 100)
              $(".DecadesDates, .graph").animate
                right: endPoint + "%"
              , ->
                moving = false
              $(".scrubber").slider "value", endPoint * 1000
            else
              $(".DecadesDates, .graph").animate
                right: "+=" + slideDistance + "%"
              , ->
                moving = false
              $(".scrubber").slider "value", $(".scrubber").slider("value") + (slideDistance * 1000)
          when 'prev'
            moveDistance = Math.abs($("article.timeline").offset().left - $(".graph").offset().left)
            if moveDistance < $(".graph").width() * (slideDistance / 100)
              $(".DecadesDates, .graph").animate
                right: "0"
              , ->
                moving = false
              $(".scrubber").slider "value", 0
            else
              $(".DecadesDates, .graph").animate
                right: "-=" + slideDistance + "%"
              , ->
                moving = false
              $(".scrubber").slider "value", $(".scrubber").slider("value") - (slideDistance * 1000)
      timeline.updateGraph($(".scrubber").slider("value"))


  initializeSheets: ->
    this.pagesPool = pagesPool = []
    itemsCollections = new DPLA.Collections.TimelineItems
    $('.timeline-row').each ->
      pagesPool.push new DPLA.Views.Timeline.Page
        el: $(this)
        items: itemsCollections

  initializeYearRotator: ->
    timeline = this
    container = $('.timelineContainer')
    $('.timeline-row .next, .timeline-row .prev').click (event) ->

      # If this is a last page or first page we need move
      current = timeline.get 'currentSheet'
      if current >= 3
        page = timeline.pagesPool.shift()
        container.append(page.$el)
        timeline.pagesPool.push page
        timeline.set 'currentSheet', current - 1
        container.animate { right: '-=100%' }, 0
      else if current <= 1
        page = timeline.pagesPool.pop()
        container.prepend(page.$el)
        timeline.pagesPool.unshift page
        timeline.set 'currentSheet', current + 1
        container.animate { right: '+=100%' }, 0

      year = timeline.get 'year'
      current = timeline.get 'currentSheet'

      $(".prev, .next").hide()
      if event.target.className == 'next'
        timeline.set
          'year': year + 1
          'currentSheet': current + 1
        timeline.scrubber.nextYear()
        $(".timelineContainer").animate
          right: "+=100%"
        , 500

      else if event.target.className == 'prev'
        timeline.set
          'year': year - 1
          'currentSheet': current - 1
        timeline.scrubber.prevYear()
        $(".timelineContainer").animate
          right: "-=100%"
        , 500

