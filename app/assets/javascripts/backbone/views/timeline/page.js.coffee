DPLA.Views.Timeline ||= {}

class DPLA.Views.Timeline.Page extends Backbone.View
  initialize: (options) ->
    this.$el    = options.el
    this.items  = options.items
    this.isRequestInProgress = false

  render: (params) ->
    page = this
    this.year   = null
    this.totalCount    = 0
    this.totalRendered = 0
    this.renderSkeleton()
    this.initializeInfinityScroll()
    if params['year']
      this.year = params['year']
      this.renderPageTitle params['year']
      this.items.requestByYear params['year'],
        beforeSend: -> page.isRequestInProgress = true
        success: (items) ->
          page.renderItems items
          page.renderTotalLabel items.totalCount
          page.totalCount = items.totalCount
        complete: ->
          page.bottomSpinner false
          page.isRequestInProgress = false
    if params['item_id']
      page.topSpinner true
      this.items.requestById params['item_id'],
        success: (item) ->
          page.renderItem item
        complete: -> page.topSpinner false

  renderPageTitle: (year) ->
    this.$el.find('.year h3').text year

  renderSkeleton: () ->
    html = JST['backbone/templates/timeline/results']()
    this.$el.find('.timelineResults').html html

  renderItems: (items) ->
    page = this
    this.$el.find('.timeline_items').append _.inject items, (html, item) ->
      page.totalRendered += 1
      html += JST['backbone/templates/timeline/item'](item.toJSON())
    , ''

  renderItem: (item) ->
    html = JST['backbone/templates/timeline/item'](item.toJSON())
    this.$el.find('.timeline_item').append html

  renderTotalLabel: (total) ->
    this.$el.find('.items_count span').html total

  topSpinner: (show = true) ->
    spinner = this.$el.find('.top_spinner')
    (show && spinner.show()) || spinner.hide()

  bottomSpinner: (show = true) ->
    spinner = this.$el.find('.bottom_spinner')
    (show && spinner.show()) || spinner.hide()

  initializeInfinityScroll: ->
    page = this
    this.$el.find('.timelineResults').on 'scroll', (event) ->
      return if page.isRequestInProgress || (page.totalRendered >= page.totalCount)
      if $(this).scrollTop() > this.scrollHeight - $(this).height() - 500
        if page.year
          page.items.requestByYear page.year,
            page: (page.totalRendered + 10) / 10
            beforeSend: ->
              page.bottomSpinner true
              page.isRequestInProgress = true
            success: (items) ->
              page.renderItems items
              page.renderTotalLabel items.totalCount
            complete: ->
              page.bottomSpinner false
              page.isRequestInProgress = false