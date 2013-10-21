jQuery ->
  return unless $('.bookshelf-container').length
  Backbone.trigger 'bookshelf:init'
  new DPLA.Routers.BookshelfRouter
  Backbone.history.start pushState: false, root: '/bookshelf'
