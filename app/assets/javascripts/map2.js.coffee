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
    this.mapCenter  = lat: 38, lng: -93
    this.zoom       = start: 4, min:  4, max: 18
    this.gridSize   = rows: 3, cols: 3
    this.page_size  = 500
    this.stateLevel = [4..6]
    this.gridLevel  = [7..12]

    this.markers =
      state:  []
      grid:   []
      normal: []

    this.loadingStack = []

    # Map initialization
    map = this.initializeMap()
    markers = this.getMarkersLayer()
    map.addLayer markers

    t = this
    this.map.on
      dragend: ->
        t.updateMarkers()
      zoomstart: ->
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
  # - requiredState
  requestItems: (options = {})->
    t = this
    data = page_size: if _.isUndefined(options['page_size']) then this.page_size else options['page_size']
    if options['state']  then data['sourceResource.spatial.state'] = options['state']
    if options['bounds'] then data['sourceResource.spatial.coordinates'] = [
      "#{options['bounds'].getNorthWest().lat},#{options['bounds'].getNorthWest().lng}"
      "#{options['bounds'].getSouthEast().lat},#{options['bounds'].getSouthEast().lng}"].join(':')

    requiredState = options['requiredState'] || -> true

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

  # Get layer with points
  getMarkersLayer: ->
    return this.markersLayer if this.markersLayer
    this.markersLayer = new L.MarkerClusterGroup
      spiderfyOnMaxZoom: false
      showCoverageOnHover: false
      zoomToBoundsOnClick: false
      iconCreateFunction: this.clusterIconBuilder

  clusterIconBuilder: (cluster) ->
    count = _.reduce cluster.getAllChildMarkers(), (total, point) ->
      total += point.count
    , 0
    new L.DivIcon
      iconSize: new L.Point(20, 20)
      className: 'dot more-results'
      html: '<div class="mapCluster"><span class="resultnumber">' + int2human(count) + '</span></div>'

  # Update markers on map
  updateMarkers: ->
    switch
      when this.isStateLevel() then this.updateStateMarkers()
      when this.isGridLevel()  then this.updateGridMarkers()
      else this.updateNormalMarkers(this.map.getBounds())

  updateStateMarkers: ->
    unless this.stateMarkers
      this.stateMarkers = _.map states, (state) ->
        icon = new L.DivIcon
          html: '<div class="mapCluster"><span class="resultnumber">' + int2human(state.count) + '</span></div>'
          className: 'dot more-results'
          iconSize: new L.Point 20, 20
        marker = new L.Marker [state.lat, state.lng], icon: icon
        _.extend marker, _.pick(state, 'name', 'count')
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
        page_size: 0
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
          marker

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
