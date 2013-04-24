class DPLA.Models.Timeline extends Backbone.Model
  defaults:
    currentSheet: 2 # By design
    totalSheets:  5 # By design
    year: 1020

  initialize: (options)->
    this.initializeSheets()
    this.initializeDecades()
    this.initializeYear()
    this.on 'timeline:decadesView', this.decadesView, this
    this.on 'timeline:yearView',    this.yearView,    this
    this.on 'timeline:updateGraph', this.updateGraph, this
    this.trigger 'timeline:initialize'

  initializeSheets: ->
    this.sheetsPool   = {}
    this.el = $('.timeContainer')
    _.each this.el.find('.timeline-row'), (sheet, i)->
      this.sheetsPool[i + 1] = sheet
    , this

  initializeDecades: ->
    this.on 'change:year timeline:initialize', ->
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

  initializeYear: ->
    this.set 'endPoint', 100
    timeline = this
    $('.graph li').on 'click', ->
      year = $(this).data 'year'
      timeline.trigger 'timeline:yearView', year
      false

  updateGraph: (year)->
    slider_value = (year - 1000) / (1020 / 100000)
    move = slider_value / 1000
    $(".DecadesDates, .graph").css right: move + "%"
    if slider_value is this.get('endPoint') * 1000
      $(".Decades .next").hide()
    else if slider_value is 0
      $(".Decades .prev").hide()
    else
      $(".Decades .prev, .Decades .next").show()

  decadesView: ->
    this.set 'mode', 'decades'
    $('.timeContainer').removeClass('yearsView').addClass('decadesView');
    $('.DecadesDates, .graph').attr('style', '');
    $('.timelineContainer').hide();
    $('.Decades').show();

  yearView: (year, item_id)->
    this.set 'mode', 'year'
    $('.timeContainer').removeClass('decadesView').addClass('yearsView');
    $('.timelineContainer').show()
    $('.Decades').hide()

  getCurrentSheet: ->
    this.sheetsPool[ this.get 'currentSheet' ]

  getWindowWidth: ->
    window.innerWidth || document.documentElement.clientWidth