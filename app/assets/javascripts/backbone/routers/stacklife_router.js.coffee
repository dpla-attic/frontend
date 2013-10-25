createStackView = _.once ->
  params = $.deparam window.location.search.replace('?', '')
  params['q'] = '' unless params['q']
  params['spec_type'] = 'Book'
  new DPLA.Views.Bookshelf.Stack
    url: '/bookshelf'
    params: params
    ribbon: ''

class DPLA.Routers.BookshelfRouter extends Backbone.Router
  routes:
    '':    'stackView'
    ':id': 'bookPreviewView'

  stackView: ->
    createStackView()
    Backbone.trigger 'bookshelf:previewunload'

  bookPreviewView: (id) ->
    createStackView()
    Backbone.trigger 'bookshelf:previewload', id


