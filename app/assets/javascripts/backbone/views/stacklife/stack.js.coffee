Backbone.on 'bookshelf:init', ->
  pivotID = null
  currentStack = null
  $window = $ window

  class DPLA.Views.Bookshelf.Stack extends DPLA.Views.Bookshelf.Base
    el: '.stack-wrapper'
    template: JST['backbone/templates/bookshelf/stack']

    initialize: (options) ->
      super options
      currentStack = @
      @$('.stackview').on 'stackview.pageload', _.bind(@highlightPivot, @)
      $window.on 'resize', _.throttle(_.bind(@handleResize, @), 100)
      $(document).on 'accordion.toggled', _.bind(@handleResize, @)
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
      windowHeight = $window.height()
      resultBarHeight = $('#resultsBarTop').outerHeight()
      asideHeight = 9999
      if $window.width() > 680
        asideHeight = $('.bookshelf > aside').outerHeight()
        asideHeight -= $('.bookshelf > aside h5').outerHeight(true)
      stackHeight = Math.min(windowHeight, asideHeight) - resultBarHeight
      @$('.stackview').height stackHeight

  Backbone.on 'bookshelf:previewload', (id) ->
    pivotID = id
    currentStack.highlightPivot() if currentStack

  Backbone.on 'bookshelf:previewunload', ->
    pivotID = null
    currentStack.unhighlightPivot() if currentStack
