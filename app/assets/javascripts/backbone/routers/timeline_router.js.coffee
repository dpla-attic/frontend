class DPLA.Routers.TimelineRouter extends Backbone.Router
  routes:
    '':               'decadesView'
    ':year':          'yearView'
    ':year/:item_id': 'yearView'

  initialize: (options) ->
    this.timeline = options.timeline
    this.timeline.router = this

  decadesView: ->
    this.timeline.trigger 'timeline:decadesView'

  yearView: (year, item_id) ->
    this.timeline.trigger 'timeline:yearView', year, item_id

