Backbone.on 'bookshelf:init', ->
  currentPreview = null

  class DPLA.Views.Bookshelf.BookPreview extends DPLA.Views.Bookshelf.Base
    el: '.preview-wrapper'
    template: JST['backbone/templates/bookshelf/bookPreview']

    render: ->
      super
      @subviews.push new DPLA.Views.Bookshelf.Relateds
        el: '.book-relateds'
        bookModel: @model
      @$el.addClass 'book-loaded'

  Backbone.on 'bookshelf:previewload', (id) ->
    book = new DPLA.Models.BookshelfBook { id: id }

    book.fetch
      success: (model, response, options) ->
        currentPreview.clear() if currentPreview && currentPreview.model
        currentPreview = new DPLA.Views.Bookshelf.BookPreview { model: model }

      error: (model, xhr, options) ->
        # appNotify.notify
        #   type: 'error'
        #   message: 'Something went wrong trying to load that book.'

  Backbone.on 'bookshelf:previewunload', ->
    if currentPreview
      currentPreview.$el.removeClass 'book-loaded'
      currentPreview.clear()
    currentPreview = null