class DPLA.Models.Timeline extends Backbone.Model
  defaults:
    currentSheet: 2 # By design
    totalSheets:  5 # By design
    year: 2000
    mode: 'decades'

  initialize: (options)->
    this.initializeDecadesView()
    this.initializeYearView()
    this.initializeDecadesPrevNext()
    this.initializeYearPrevNext()
    this.initializeYearRotator()
    this.on 'timeline:decadesView', this.decadesView, this
    this.on 'timeline:yearView',    this.yearView,    this
    this.on 'change:year', this.updateGraph, this
    this.on 'timeline:update_url', this.updateRoute, this

  updateGraph: ->
    slider_value = (this.get('year') - 1000) / (1020 / 100000)
    move = slider_value / 1000
    $(".DecadesDates, .graph").css right: move + "%"
    if slider_value is this.get('endPoint') * 1000
      $(".Decades .next").hide()
    else if slider_value is 0
      $(".Decades .prev").hide()
    else
      $(".Decades .prev, .Decades .next").show()

  updateRoute: ->
    year = this.get 'year'
    switch this.get 'mode'
      when 'decades'
        this.router.navigate '', trigger: false
      when 'year'
        this.router.navigate "#{year}", trigger: false


  decadesView: ->
    this.set 'mode', 'decades'
    $('.timeContainer').removeClass('yearsView').addClass('decadesView');
    $('.DecadesDates, .graph').attr('style', '');
    $('.timelineContainer').hide();
    $('.Decades').show();

  yearView: (year, item_id)->
    this.set 'mode', 'year'
    this.set 'year', year
    $('.timeContainer').removeClass('decadesView').addClass('yearsView');
    $('.timelineContainer').show()
    $('.Decades').hide()

  getCurrentSheet: ->
    this.sheetsPool[ this.get 'currentSheet' ]

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
      timeline.trigger 'timeline:decadesView'
      false

  initializeYearView: ->
    this.on 'timeline:yearView', ->
      this.set 'endPoint', 100
    timeline = this
    $('.graph li').on 'click', ->
      year = $(this).data 'year'
      timeline.trigger 'timeline:yearView', year
      false

  initializeDecadesPrevNext: ->
    slideDistance = this.get 'slideDistance'
    endPoint = this.get 'endPoint'
    moving = false
    $('.Decades span.next, .Decades span.prev').on 'click', ->
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
      $(".scrubber").slider "value", $(".scrubber").slider("value") + 98.039257
      $(".prev, .next").hide()
      $(".timelineContainer").animate
        right: "+=100%"
      , 500, ->
        if timeline.get('year') is 2013
          $(".prev").show()
        else
          $(".prev, .next").show()


    $(".timeline-row .prev").click ->
      if $(this).parent().prev().hasClass("timeline-row")
        $(".scrubber").slider "value", $(".scrubber").slider("value") - 98.039257
        $(".prev, .next").hide()
        $(".timelineContainer").animate
          right: "-=100%"
        , 500, ->
          if timeline.get('year') is 1000
            $(".next").show()
          else
            $(".prev, .next").show()

  initializeYearRotator: ->
    timeline = this
    container = $('.timelineContainer')
    $('.timelineContainer .timeline-row').click (event) ->
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
          'year': current_year + 1
          'currentSheet': current_sheet + 1

      else if event.target.className == 'prev'
        year = current_year-1
        _page = page.prev()
        # fetchPage(year, _page) unless _page.find('.year h3').text() == year.toString()
        # container.animate { right: '-=100%' }, 500, ->
        #   $('.prev, .next').show()
        # $('.scrubber').slider('value', $('.scrubber').slider('value') - 98.039257);
        timeline.set
          'year': current_year - 1
          'currentSheet': current_sheet - 1