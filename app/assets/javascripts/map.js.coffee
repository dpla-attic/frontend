$ ->
  if $('.map-controller').length
    window.map = new DPLAMap()

window.int2human = (int) ->
  switch
    when int > 999 && int <= 999999
      "#{ Math.round(int / 1000) }K"
    when int > 999999
      "#{ Math.round(int / 1000 / 1000) }M"
    else
      int

DPLAMap = L.Class.extend
  initialize: ->
    # configurable params
    this.mapCenter  = lat: _.first(config.center), lng: _.last(config.center)
    this.zoom       = config.zoom
    this.gridSize   = config.grid_size
    this.stateLevel = [_.first(config.state_level).._.last(config.state_level)]
    this.gridLevel  = [_.first(config.grid_level).._.last(config.grid_level)]
    this.page_size  = config.page_size
    this.popup_page_size  = config.popup_page_size

    this.markers =
      state:  []
      grid:   []
      normal: []

    this.loadingStack = []
    this.openPopups   = []

    # Map initialization
    map = this.initializeMap()
    markers = this.getMarkersLayer()
    map.addLayer markers

    t = this
    this.map.on
      dragstart: ->
        t.closeAllPopups()
      zoomstart: ->
        t.closeAllPopups()
      dragend: ->
        t.updateMarkers()
      zoomend: ->
        t.updateMarkers()

    # Start here
    this.updateMarkers()

  # Initialize map with tiles layer from OSM
  initializeMap: ->
    return this.map if this.map
    this.map = L.map 'map',
      center: new L.LatLng(this.mapCenter.lat, this.mapCenter.lng)
      zoom: this.zoom.start
      layers: L.tileLayer 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        minZoom: this.zoom.min
        maxZoom: this.zoom.max
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'

  # Perform JSONP request to DPLA API
  # Options:
  # - bounds
  # - state
  # - page_size
  # - beforeSend
  # - success
  # - complete
  requestItems: (options = {})->
    t = this
    data = page_size: if _.isUndefined(options['page_size']) then this.page_size else options['page_size']
    if options['state']  then data['sourceResource.spatial.state'] = options['state']
    if options['bounds'] then data['sourceResource.spatial.coordinates'] = [
      "#{options['bounds'].getNorthWest().lat},#{options['bounds'].getNorthWest().lng}"
      "#{options['bounds'].getSouthEast().lat},#{options['bounds'].getSouthEast().lng}"].join(':')

    $.ajax
      url: window.api_search_path
      data: data
      dataType: 'jsonp'
      cache: true
      beforeSend: (jqXHR, settings) ->
        t.turnProgress()
        options.beforeSend(jqXHR, settings) if options.beforeSend
        true
      success: (data, textStatus, jqXHR) ->
        data.docs = _.map data.docs, (doc) -> t.doc2point(doc) unless _.isEmpty data.docs
        options.success(data, textStatus, jqXHR) if options.success
        true
      complete: (jqXHR, textStatus) ->
        t.turnProgress(false)
        options.complete(jqXHR, textStatus) if options.complete

  # Get grid boundaries splitted by map
  getGrid: ->
    t = this
    pos = this.getPosition()
    colWidth  = Math.abs(pos.northWest.lng - pos.northEast.lng) / this.gridSize.cols
    rowHeight = Math.abs(pos.northWest.lat - pos.southWest.lat) / this.gridSize.rows

    _.map [0..t.gridSize.cols - 1], (colNumber) ->
      _.map [0..t.gridSize.rows - 1], (rowNumber) ->
        topLeft = new L.LatLng(
          pos.northWest.lat - rowHeight * rowNumber,
          pos.northWest.lng + colWidth * colNumber)
        bottomRight = new L.LatLng(topLeft.lat - rowHeight, topLeft.lng + colWidth)
        new L.LatLngBounds(topLeft, bottomRight)

  # Get current map position and zoom
  getPosition: ->
    bounds = this.map.getBounds()
    southWest: bounds.getSouthWest()
    northWest: bounds.getNorthWest()
    southEast: bounds.getSouthEast()
    northEast: bounds.getNorthEast()
    center:    this.map.getCenter()
    zoom:      this.map.getZoom()

  getPositionHash: ->
    [this.map.getCenter().lat, this.map.getCenter().lng, this.map.getZoom()].join(':')

  getBackUri: ->
    base_uri = window.location.href
    if window.location.href.indexOf('#') > 0
      base_uri = base_uri.substr(0, window.location.href.indexOf('#'))
    pos = this.getPosition()
    back_uri = "#{ base_uri }#/?lat=#{ pos.center.lat }&lng=#{ pos.center.lng }&zoom=#{ pos.zoom }"
    encodeURIComponent(back_uri)

  # Get layer with points
  getMarkersLayer: ->
    t = this
    return this.markersLayer if this.markersLayer
    this.markersLayer = new L.MarkerClusterGroup
      spiderfyOnMaxZoom: false
      showCoverageOnHover: false
      zoomToBoundsOnClick: false
      maxClusterRadius: 45
      iconCreateFunction: (cluster) ->
        count = _.reduce cluster.getAllChildMarkers(), (total, point) ->
          total += point.count
        , 0
        new L.DivIcon
          iconSize: new L.Point(20, 20)
          className: 'dot more-results'
          html: '<div class="mapCluster"><span class="resultnumber">' + int2human(count) + '</span></div>'
    this.markersLayer.on 'clusterclick', (cluster) ->
      childs = cluster.layer.getAllChildMarkers()
      switch _.first(_.map childs, (c) -> c.type)
        when 'state'
          state = _.first(childs.sort (a,b) -> b.count - a.count)
          t.openStatePopup latlng: cluster.layer.getLatLng(), state: state.data.name
        when 'normal'
          t.openPopup latlng: cluster.layer.getLatLng(), points: _.map(childs, (m) -> m.data )

  renderPopup: (options) ->
    t = this
    html = ''
    _.each options.points, (point) ->
      item_href = "/item/#{ point.id }?back_uri=#{ t.getBackUri() }"
      item_title = point.title
      if $.isArray(item_title)
        item_title = item_title[0]
      content =
        """
          <h6> #{ point.type }</h6>
          <h4><a href="#{ item_href }" target="_blank">#{ item_title }</a></h4>
          <p><span> #{ point.creator }</span></p>
          <p><span> #{ point.created_date }</span></p>

          <a class="ViewObject" href="#{ point.url }" target="_blank">View Object <span class="icon-view-object" aria-hidden="true"></span></a>
        """
      if point.thumbnail
        default_image = switch
          when point.type == "image" then window.default_images.image
          when point.type == "sound" then window.default_images.sound
          when point.type == "video" then window.default_images.video
          else default_images.text
        html +=
          """
            <div class="box-row">
              <div class="box-right"><img onerror="image_loading_error(this);" src="#{ point.thumbnail }" data-default-src="#{ default_image }" /></div>
              <div class="box-left">#{ content }</div>
            </div>
          """
      else
        html += "<div class=\"box-row\">#{ content }</div>"

    html = '<div class="box-rows">' + html + '</div>' if options.points.length > 1
    html = "<h5>#{ options.title }</h5>" + html if options.title
    html

  # Open popup
  # Options
  # - latlng
  # - points
  # - title
  openPopup: (options) ->
    if options.points.length > 1 and _.isEmpty(options.title)
      location = this.getClusterLocation(options.points)
      titleHref = "/search?#{ window.app_search_path }&place[]=#{ location }"
      options.title = "<a href=\"#{ titleHref }\">#{ location }</a>"

    popup = new DPLAPopup offset: new L.Point(-10,-30)
    popup.setContent this.renderPopup(title: options.title, points: options.points)
    popup.setLatLng(options.latlng)
    this.openPopups.push popup.openOn(this.map, {x: 20, y: 10})

  # Open state popup
  # Options:
  # - latlng
  # - state
  openStatePopup: (options) ->
    t = this
    titleHref = "/search?#{ window.app_search_path }&state[]=#{ options.state }"
    title = "<a href=\"#{ titleHref }\">#{ options.state }</a>"
    this.requestItems
      page_size: t.popup_page_size
      state: options.state
      success: (data) -> t.openPopup latlng: options.latlng, points: data.docs, title: title

  # Open grid popup
  # Options:
  # - latlng
  # - bounds
  openGridPopup: (options) ->
    t = this
    this.requestItems
      page_size: t.popup_page_size
      bounds: options.bounds
      success: (data) -> t.openPopup latlng: options.latlng, points: data.docs

  # Update markers on map
  updateMarkers: ->
    switch
      when this.isStateLevel() then this.updateStateMarkers()
      when this.isGridLevel()  then this.updateGridMarkers()
      else this.updateNormalMarkers(this.map.getBounds())

  updateStateMarkers: ->
    t = this
    unless this.stateMarkers
      this.stateMarkers = _.map states, (state) ->
        icon = new L.DivIcon
          html: '<div class="mapCluster"><span class="resultnumber">' + int2human(state.count) + '</span></div>'
          className: 'dot more-results'
          iconSize: new L.Point 20, 20
        marker = new L.Marker [state.lat, state.lng], icon: icon
        marker.type = 'state'
        marker.count = state.count
        marker.data = _.pick(state, 'name')
        marker.on 'click', (e) -> t.openStatePopup latlng: e.target.getLatLng(), state: e.target.data.name
        marker

    this.markers.state = this.stateMarkers
    this.getMarkersLayer().addLayers(this.markers.state)

    this.removeGridMarkers()
    this.removeNormalMarkers()

  updateGridMarkers: ->
    t = this
    positionHash = t.getPositionHash()
    _.each _.flatten(t.getGrid()), (cellBounds) ->
      t.requestItems
        page_size: t.page_size
        bounds: cellBounds,
        success: (data) ->
          return if t.getPositionHash() isnt positionHash
          if data.count < t.page_size
            t.updateNormalMarkers(cellBounds)
          else
            t.removeStateMarkers(cellBounds)
            t.removeGridMarkers(cellBounds)
            t.removeNormalMarkers(cellBounds)

            icon = new L.DivIcon
              html: '<div class="mapCluster"><span class="resultnumber">' + int2human(data.count) + '</span></div>'
              className: 'dot more-results'
              iconSize: new L.Point 20, 20
            marker = new L.Marker cellBounds.getCenter(), icon: icon
            marker.count = data.count
            marker.type = 'grid'
            marker.on 'click', (e) -> t.openGridPopup latlng: e.target.getLatLng(), bounds: cellBounds

            t.markers.grid.push(marker)
            t.getMarkersLayer().addLayer(marker)

  updateNormalMarkers: (bounds) ->
    t = this
    positionHash = t.getPositionHash()
    t.requestItems
      bounds: bounds
      success: (data) ->
        return if t.getPositionHash() isnt positionHash
        t.removeStateMarkers(bounds)
        t.removeGridMarkers(bounds)
        t.removeNormalMarkers(bounds)

        markers = _.map data.docs, (point) ->
          icon = new L.DivIcon
            className: 'dot'
            iconSize: new L.Point 0, 0
          marker = new L.Marker [point.lat, point.lng], icon: icon
          marker.count = 1
          marker.type = 'normal'
          marker.data = point
          marker.on 'click', (e) -> t.openPopup latlng: e.target.getLatLng(), points: [e.target.data]

        t.markers.normal = t.markers.normal.concat(markers)
        t.getMarkersLayer().addLayers(markers)

  removeStateMarkers: (bounds) ->
    if bounds
      toDelete = _.filter this.markers.state, (marker) -> bounds.contains marker.getLatLng()
      this.markers.state = _.difference(this.markers.state, toDelete)
    else
      toDelete = this.markers.state
      this.markers.state = []
    this.getMarkersLayer().removeLayers(toDelete)


  removeGridMarkers: (bounds) ->
    if bounds
      toDelete = _.filter this.markers.grid, (marker) -> bounds.contains marker.getLatLng()
      this.markers.grid = _.difference(this.markers.grid, toDelete)
    else
      toDelete = this.markers.grid
      this.markers.grid = []
    this.getMarkersLayer().removeLayers(toDelete)

  removeNormalMarkers: (bounds) ->
    if bounds
      toDelete = _.filter this.markers.normal, (marker) -> bounds.contains marker.getLatLng()
      this.markers.normal = _.difference(this.markers.normal, toDelete)
    else
      toDelete = this.markers.normal
      this.markers.normal = []
    this.getMarkersLayer().removeLayers(toDelete)

  isStateLevel: -> _.indexOf(this.stateLevel, this.getPosition().zoom) isnt -1

  isGridLevel: -> _.indexOf(this.gridLevel, this.getPosition().zoom) isnt -1

  turnProgress: (state = true) ->
    if state then this.loadingStack.push(true) else this.loadingStack.pop()
    if _.isEmpty(this.loadingStack)
      $('#loading').hide()
    else
      $('#loading').show()

  getClusterLocation: (points) ->
    locations = {}
    $.each points, (i, point) ->
      $.each point.location, (i,loc) ->
        if locations[loc]
          locations[loc]++
        else
          locations[loc] = 1
    locationName = ''
    locationScore = 0
    $.each locations, (name, score) ->
      if locationScore < score
        locationName = name
        locationScore = score
    locationName

  closeAllPopups: ->
    _.each this.openPopups, (popup) -> popup._close()

  doc2point: (doc)->
    coordinates = []
    if $.isArray(doc['sourceResource.spatial.coordinates'])
      coordinates = try
        doc['sourceResource.spatial.coordinates'][0].split ','
      catch error
        []
    else if doc['sourceResource.spatial.coordinates']
      coordinates = doc['sourceResource.spatial.coordinates'].split ','
    location = doc['sourceResource.spatial.name']
    location = [location] unless location instanceof Array
    date = doc['sourceResource.date']
    created_date = date['displayDate'] if typeof date isnt 'undefined'
    created_date = created_date.join(', ') if _.isArray(created_date)
    point =
      id: doc.id
      title: doc['sourceResource.title'] || doc['id']
      thumbnail: doc['object']
      type: doc['sourceResource.type'] || ''
      creator: doc['sourceResource.creator'] || ''
      location: location
      url: doc['isShownAt']
      lat: coordinates.shift()
      lng: coordinates.shift()
      created_date: created_date || ''


DPLAPopup = L.Popup.extend
  _initLayout: ->
    this._container = mapBox = L.DomUtil.create 'div', 'mapBox'
    L.DomEvent.disableClickPropagation mapBox
    closeButton = L.DomUtil.create 'a', 'closePopUp', mapBox
    closeButton.href = '#close'
    closeButton.innerHTML = '&#215;'
    L.DomEvent.on closeButton, 'click', this._onCloseButtonClick, this
    this._contentNode = L.DomUtil.create 'div', 'boxInner', mapBox
    L.DomEvent.on(this._contentNode, 'mousewheel', L.DomEvent.stopPropagation)
    this._tip = L.DomUtil.create('div', 'mapArrow', mapBox)
  _updateLayout: ->
    container = this._contentNode
    this._containerWidth = container.offsetWidth
    this._container.style.bottom = 50 + 'px'
    this._container.style.left = 50 + 'px'
  openOn: (m, adjust = {x: 10, y: 20})->
    L.Popup.prototype.openOn.call(this, m)
    this._container.style.left = (this._containerLeft + adjust.x) + 'px'
    this._container.style.bottom = (this._containerBottom + adjust.y) + 'px'
    return this;
