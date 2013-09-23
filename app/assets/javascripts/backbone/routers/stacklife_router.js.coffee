parseQueryString = (queryString) ->
  params = {}
  if queryString
    queryString = queryString.substr 1
    mapped = _.map decodeURIComponent(queryString).split(/&/g), (el, i) ->
      aux = el.split '='
      obj = {}
      if aux.length >= 1
        val = undefined
        if aux.length == 2
          val = aux[1]
        obj[aux[0]] = val
      obj
    _.each mapped, (obj) -> _.extend params, obj
  params

createStackView = _.once ->
  params = parseQueryString window.location.search
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


