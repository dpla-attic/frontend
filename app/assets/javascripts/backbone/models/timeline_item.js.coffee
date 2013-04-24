class DPLA.Models.TimelineItem extends Backbone.Model
  paramRoot: 'timeline_item'

class DPLA.Collections.TimelineItems extends Backbone.Collection
  model: DPLA.Models.TimelineItem
  url: '/timeline_items'

  initialize: (options) ->
    this.timeline = options.timeline

  fetchByYear: (year) ->
    timeline = this.timeline
    $.ajax
      url: window.api_search_path
      dataType: 'jsonp'
      cache: true
      data:
        'sourceResource.date.begin': year
      beforeSend: ->
        timeline.trigger 'spiner:top:start'
      complete: ->
        timeline.trigger 'spiner:top:stop'

  fetchById: (item_id)->
    timeline = this.timeline
    $.ajax
      url: window.api_item_path.replace '%', item_id
      dataType: 'jsonp'
      cache: true
      beforeSend: ->
        timeline.trigger 'spiner:bottom:start'
      complete: ->
        timeline.trigger 'spiner:bottom:stop'
