class DPLA.Models.TimelineItem extends Backbone.Model
  initialize: ({}, doc) ->
    id    = doc['id'] || ''
    title = doc['sourceResource.title'] || id
    title = _.first(title) if _.isArray(title)
    description = doc['sourceResource.description'] || ''
    description = description.substr(0, 200) + '...' if description.length > 200
    this.set
      id:          id
      type:        doc['sourceResource.type'] || ''
      title:       title
      creator:     doc['sourceResource.creator'] || ''
      description: description
      source:      doc['isShownAt'] || ''
      thumbnail:   doc['object']    || ''

class DPLA.Collections.TimelineItems extends Backbone.Collection
  fetchByYear: (year) ->
    this.requestByYear year,
      beforeSend: ->
      success: (items) ->
        console.log items
      complete: ->

  fetchById: (item_id) ->
    this.requestById item_id,
      success: (items) ->
        console.log items

  requestByYear: (year, options = {}) ->
    count   = options.count || 10
    page    = options.page  || 1
    $.ajax
      url: window.api_search_path
      dataType: 'jsonp'
      cache: true
      data:
        'sourceResource.date.begin': year
        'page_size': count
        'page': page
      beforeSend: ->
      success: (data) ->
        items = []
        if _.isObject(data) && _.isArray(data.docs)
          items = _.map data.docs, (doc) ->
            new DPLA.Models.TimelineItem({}, doc)
        options.success(items)
      complete: ->

  requestById: (item_id, options) ->
    success = options.success
    $.ajax
      url: window.api_item_path.replace '%', item_id
      dataType: 'jsonp'
      cache: true
      beforeSend: ->
      success: (data) ->
        items = []
        if _.isObject(data) && _.isArray(data.docs)
          items = _.map data.docs, (doc) ->
            new DPLA.Models.TimelineItem({}, doc)
        success(items)
      complete: ->
