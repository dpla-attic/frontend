class DPLA.Models.Timeline extends Backbone.Model
  defaults:
    currentSheet: 2 # By design
    totalSheets:  5 # By design
    year: 2000
    minYear: 1000
    maxYear: 2020

  initialize: (options) ->
    this.initializeDecadesView()
    this.initializeYearView()
    this.initializeDecadesPrevNext()
    this.initializeYearPrevNext()
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

    if this.sliderWas && this.yearWas == this.get('year').toString()
      this.scrubber.$el.slider('value', this.sliderWas)

  yearView: (year, item_id) ->
    try
      this.yearWas   = this.get('year')
      this.sliderWas = this.scrubber.$el.slider('value')

    this.set 'mode', 'year'
    this.set 'year', year
    this.trigger 'timeline:update_scrubber', this
    $('.timeContainer').removeClass('decadesView').addClass('yearsView');
    $('.timelineContainer').show()
    $('.Decades').hide()


    page = this.getCurrentSheet()
    if this.get('year') is this.get('maxYear')
      page.find('.prev').show()
      page.find('.next').hide()
    else if this.get('year') is this.get('minYear')
      page.find('.prev').hide()
      page.find('.next').show()
    else
      page.find('.prev, .next').show()

    items = new DPLA.Collections.TimelineItems page: page
    items.fetchByYear year
    if item_id
      items.fetchById item_id

  getCurrentSheet: ->
    current_sheet = timeline.get 'currentSheet'
    $('.timelineContainer').find(".timeline-row:nth-child("+ current_sheet + ")")

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

  initializeYearPrevNext: ->
    timeline = this
    $(".timeline-row .next").click ->
      $(".prev, .next").hide()
      $(".timelineContainer").animate
        right: "+=100%"
      , 500, ->
        if timeline.get('year') is 2020
          $(".prev").show()
        else
          $(".prev, .next").show()
      timeline.scrubber.nextYear()
      year = timeline.scrubber.getSliderYear()
      timeline.router.navigate "//#{year}"


    $(".timeline-row .prev").click ->
      if $(this).parent().prev().hasClass("timeline-row")
        $(".prev, .next").hide()
        $(".timelineContainer").animate
          right: "-=100%"
        , 500, ->
          if timeline.get('year') is 1000
            $(".next").show()
          else
            $(".prev, .next").show()
        timeline.scrubber.prevYear()
        year = timeline.scrubber.getSliderYear()
        timeline.router.navigate "//#{year}"

  initializeYearRotator: ->
    timeline = this
    container = $('.timelineContainer')
    $('.timeline-row .next, .timeline-row .prev').click (event) ->
      current_year = timeline.get 'year'
      current_sheet = timeline.get 'currentSheet'
      total_sheets  = timeline.get 'totalSheets'

      page = container.find(".timeline-row:nth-child("+ current_sheet + ")")

      # If this is a last page or first page we need move
      if current_sheet >= 4
        container.append(container.find('.timeline-row:first-child'))
        current_sheet = current_sheet-1
        container.animate { right: '-=100%' }, 0
      else if current_sheet <= 2
        container.prepend(container.find('.timeline-row:last-child'))
        current_sheet = current_sheet+1
        container.animate { right: '+=100%' }, 0

      if event.target.className == 'next'
        year = current_year+1
        _page = page.next()
        # fetchPage(year, _page) unless _page.find('.year h3').text() == year.toString()
        # container.animate { right: '+=100%' }, 500, ->
        #   $('.prev, .next').show()
        # $('.scrubber').slider('value', $('.scrubber').slider('value') + 98.039257);
        timeline.set
          'year': current_year
          'currentSheet': current_sheet + 1

      else if event.target.className == 'prev'
        year = current_year-1
        _page = page.prev()
        # fetchPage(year, _page) unless _page.find('.year h3').text() == year.toString()
        # container.animate { right: '-=100%' }, 500, ->
        #   $('.prev, .next').show()
        # $('.scrubber').slider('value', $('.scrubber').slider('value') - 98.039257);
        timeline.set
          'year': current_year
          'currentSheet': current_sheet - 1