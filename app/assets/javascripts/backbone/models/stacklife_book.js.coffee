Backbone.on 'bookshelf:init', ->
  class DPLA.Models.BookshelfBook extends Backbone.Model
    urlRoot: '/item'