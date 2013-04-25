class DPLA.Views.TimelineScrubber extends Backbone.View
  initialize: (options) ->
    this.timeline = options.timeline
    this.timeline.scrubber = this
    this.$el = $('.scrubber')
    this.timeline.on 'timeline:update_scrubber', this.updateScrubber, this
    this.timeline.on 'change:mode', this.changeMode, this

  changeMode: (timeline) ->
    mode  = timeline.get('mode')
    year  = timeline.get('year')
    value = this.getSliderValue()
    if mode is 'decades'
      value -= 100000
    t = this
    this.$el.slider
      value: value
      min: 0
      max: timeline.get('endPoint') * 1000
      slide: (event, ui) ->
        switch mode
          when 'decades'
            year = t.getSliderYear(t)
            t.timeline.set('year', year)
            timeline.trigger 'timeline:update_graph', ui.value
          when 'year'
            year = t.getSliderYear(t)
      change: (event, ui) ->
        switch mode
          when 'decades'
            year = t.getSliderYear(t)
            t.timeline.set('year', year)
            timeline.trigger 'timeline:update_graph', ui.value
          when 'year'
            year = t.getSliderYear(t)
            if year.toString() != t.timeline.get('year')
              t.timeline.router.navigate "//#{year}"

    unless $('.scrubber a span.arrow').length
      $('.scrubber a').append('<span class="arrow"></span><span class="icon-arrow-down" aria-hidden="true"></span>');

    setTimeout ->
      timeline.trigger 'timeline:update_graph', t.$el.slider('value')
    , 100

  updateScrubber: (timeline) ->
    year = timeline.get('year')
    value = this.getSliderValue()
    this.$el.slider('value', value)

  getSliderValue: ->
    year = Math.round(this.timeline.get 'year')
    switch this.timeline.get 'mode'
      when 'decades'
        (year * 100000) / 1020 - 4000
      when 'year'
        (year - 1000) * 100000 / 1020

  getSliderYear: ->
    value = this.$el.slider('value')
    switch this.timeline.get 'mode'
      when 'decades'
        Math.round (value + 4000) * 1020 / 100000
      when 'year'
        1000 + Math.round (value) * 1020 / 100000

  nextYear: ->
    this.$el.slider "value", this.$el.slider("value") + 98.039257

  prevYear: ->
    this.$el.slider "value", this.$el.slider("value") - 98.039257