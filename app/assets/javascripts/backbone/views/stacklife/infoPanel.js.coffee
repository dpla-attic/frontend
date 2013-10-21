Backbone.on 'bookshelf:init', ->
  class DPLA.Views.Bookshelf.InfoPanel extends DPLA.Views.Bookshelf.Base
    el: '.bookshelf-container'
    template: JST['backbone/templates/bookshelf/infoPanel']

    events:
      'click .toggle-infopanel': 'toggle'

    render: ->
      @$('.stack-wrapper').before @template()

    show: ->
      @$el.addClass 'infopanel-on'

    hide: ->
      @$el.removeClass 'infopanel-on'

    toggle: (event) ->
      @$el.toggleClass 'infopanel-on'
      event.preventDefault()

  infoPanel = new DPLA.Views.Bookshelf.InfoPanel

  Backbone.on 'bookshelf:previewload', ->
    infoPanel.hide()
  Backbone.on 'bookshelf:previewunload', ->
    infoPanel.show()
