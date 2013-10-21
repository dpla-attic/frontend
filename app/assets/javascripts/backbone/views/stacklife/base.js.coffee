DPLA.Views.Bookshelf = {}

class DPLA.Views.Bookshelf.Base extends Backbone.View
  initialize: (options) ->
    super options
    @subviews = []
    @template = @template ? options.template
    @render()

  render: ->
    data =
      model: @model ? {}
      collection: @collection ? {}
      helpers: @helpers
    @$el.html @template(data)

  destroy: ->
    _.invoke @subviews, 'destroy'
    @undelegateEvents()
    @remove()

  clear: ->
    _.invoke @subviews, 'destroy'
    @undelegateEvents()
    @$el.empty()

  redraw: ->
    @clear()
    @render()
    @delegateEvents()
