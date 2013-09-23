Backbone.on 'bookshelf:init', ->
  pivotID = null
  currentStack = null

  class DPLA.Views.Bookshelf.Stack extends DPLA.Views.Bookshelf.Base
    el: '.stack-wrapper'
    template: JST['backbone/templates/bookshelf/stack']

    initialize: (options) ->
      super options
      currentStack = @
      @$('.stackview').on 'stackview.pageload', _.bind(@highlightPivot, @)
      jQuery(window).on 'resize', _.throttle(_.bind(@handleResize, @), 100)
      @handleResize()

    render: ->
      super
      if @options.selectFirstBook
        @$('.stackview').one 'stackview.pageload', _.bind(@selectFirstBook, @)
      @$('.stackview').stackView @options

    selectFirstBook: ->
      $first = @$('.stack-item').first()
      return unless $first.length
      id = $first.data('stackviewItem').id
      Backbone.trigger 'bookshelf:previewload', id

    highlightPivot: ->
      @unhighlightPivot()
      $pivot = @$('.stack-item').filter ->
        jQuery(@).data('stackviewItem').id is pivotID
      $pivot.addClass 'stack-pivot'

    unhighlightPivot: ->
      @$('.stack-pivot').removeClass 'stack-pivot'

    handleResize: ->
      windowHeight = $(window).height()
      resultBarHeight = $('#resultsBarTop').outerHeight()
      @$('.stackview').height windowHeight - resultBarHeight

  Backbone.on 'bookshelf:previewload', (id) ->
    pivotID = id
    currentStack.highlightPivot() if currentStack

  Backbone.on 'bookshelf:previewunload', ->
    pivotID = null
    currentStack.unhighlightPivot() if currentStack
