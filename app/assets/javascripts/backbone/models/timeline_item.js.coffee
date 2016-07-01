class DPLA.Models.TimelineItem extends Backbone.Model
  initialize: ({}, doc) ->
    id    = doc['id'] || ''
    title = doc['sourceResource.title'] || id
    title = _.first(title) if _.isArray(title)
    description = doc['sourceResource.description'] || ''
    description = _.first(description) if _.isArray(description)
    description = description.substr(0, 200) + '...' if description.length > 200
    date = doc['sourceResource.date']
    created_date = date['displayDate'] if typeof date isnt 'undefined'
    created_date = created_date.join(', ') if _.isArray(created_date)
    data_provider = doc['dataProvider']
    data_provider = data_provider.join(', ') if _.isArray(data_provider)
    this.set
      id:          id
      type:        doc['sourceResource.type'] || ''
      title:       title
      creator:     doc['sourceResource.creator'] || ''
      description: description
      source:      doc['isShownAt'] || ''
      thumbnail:   doc['object']    || ''
      highlight:   false
      created_date:  created_date || ''
      data_provider: data_provider || ''

class DPLA.Collections.TimelineItems extends Backbone.Collection
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
      beforeSend: options.beforeSend
      success: (data) ->
        items = []
        data = $.parseJSON(data) unless _.isObject(data)
        if _.isObject(data) && _.isArray(data.docs)
          items = _.map data.docs, (doc) ->
            new DPLA.Models.TimelineItem({}, doc)
          items.totalCount = data.count if data.count
        options.success(items)
      complete: options.complete

  requestById: (item_id, options) ->
    success = options.success
    $.ajax
      url: window.api_item_path.replace '%', item_id
      dataType: 'jsonp'
      cache: true
      success: (data) ->
        if _.isObject(data) && _.isArray(data.docs)
          success(new DPLA.Models.TimelineItem({}, _.first(data.docs)))
      complete: options.complete
