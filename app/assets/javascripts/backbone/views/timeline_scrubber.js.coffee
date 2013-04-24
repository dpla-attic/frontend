class DPLA.Views.TimelineScrubber extends Backbone.View
  initialize: (options)->
    this.timeline = options.timeline
    this.$el = $('.scrubber')
    this.timeline.on 'change:year', this.changeYear, this
    this.timeline.on 'change:mode', this.changeMode, this

  changeMode: (timeline) ->
    mode  = timeline.get('mode')
    year  = timeline.get('year')
    value = this.getSliderValue(this)
    t = this
    this.$el.slider
      value: value
      min: 0
      max: timeline.get('endPoint') * 1000
      slide: (event, ui)->
        # switch mode
        #   when 'decades'
        #   when 'year'
      change: (event, ui)->
        year = t.getSliderYear t
        timeline.set('year', year)
        timeline.trigger 'timeline:update_url'

  changeYear: (timeline) ->
    year = timeline.get('year')
    value = this.getSliderValue(this)
    this.$el.slider('value', value)

  getSliderValue: (scrubber)->
    year = Math.round(scrubber.timeline.get 'year')
    switch scrubber.timeline.get 'mode'
      when 'decades'
        (year * 100000) / 1020 - 4000
      when 'year'
        (year - 1000) * 100000 / 1020

  getSliderYear: (scrubber)->
    value = scrubber.$el.slider('value')
    switch scrubber.timeline.get 'mode'
      when 'decades'
        Math.round (value + 4000) * 1020 / 100000
      when 'year'
        1000 + Math.round (value) * 1020 / 100000
