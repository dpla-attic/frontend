DPLA.Views.Timeline ||= {}

class DPLA.Views.Timeline.Page extends Backbone.View
  initialize: (options) ->
    this.$el   = options.el
    this.items = options.items

  render: (params) ->
    # this.$el
    # this.items
    this.setYear params['year'] if params['year']
    # console.log params
    this.items.fetchByYear

  setYear: (year) ->
    # console.log (year)
    $(this.$el.find('.year h3')).text year
    # console.log $(this.$el.find('.year h3')