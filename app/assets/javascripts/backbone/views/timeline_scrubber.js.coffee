class DPLA.Views.TimelineScrubber extends Backbone.View
  initialize: (options)->
    this.timeline = options.timeline
    timeline.on 'change:mode', this.changeMode, this

  changeMode: (timeline, mode) ->
    switch mode
      when 'decades'
        $(".scrubber").slider
          value: (timeline.get('year') * 100000) / 1020 - 4000
          min: 0
          max: timeline.get('endPoint') * 1000
          slide: (event, ui) ->
            year = ui.value * 1020 / 100000 + 1000
            timeline.trigger 'timeline:updateGraph', year
          change: (event, ui) ->
            year = ui.value * 1020 / 100000 + 1000
            timeline.trigger 'timeline:updateGraph', year
            timeline.set 'year', year
      when 'year'
        $(".scrubber").slider
          value: (timeline.get('year') * 100000) / 1020
          min: 0
          max: timeline.get('endPoint') * 1000
          change: (event, ui) ->
            year = ui.value * 1020 / 100000 + 1000
            timeline.set 'year', year

    setTimeout ->
      value = $(".scrubber").slider('value')
      year = value * 1020 / 100000 + 1000
      timeline.trigger 'timeline:updateGraph', year
    , 0