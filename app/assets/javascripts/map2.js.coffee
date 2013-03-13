$(document).ready ->
  wrapper = new MapWrapper('map')
  map = wrapper.map
  $('#toggle').on 'click', ->
    setTimeout ->
      map.invalidateSize()
    , 1000

  # map variable for debugging purposes
  window.map     = map
  window.wrapper = wrapper

MapWrapper = L.Class.extend
  _layers: {}
  _drawedItems: {}
  _requestsPool: []

  initialize: (domId)->
    this.map = L.map 'map'
      center: new L.LatLng(38, -93)
      zoom: 4
      layers: this.getBaseLayer()
    self = this
    this.map.on
      dragend: ->
        self.onDragend()
      zoomend: ->
        self.onZoomend()
    this.loadMarkers()

  getBaseLayer: ->
    unless this._layers.base
      tileUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
      copyright = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
      this._layers.base = L.tileLayer tileUrl, attribution: copyright, minZoom: 4, maxZoom: 18
    this._layers.base

  getStateLayer: ->
    unless this._layers.state
      statesPoints = []
      if window.states instanceof Array
        $.each window.states, (i,state)->
          point = new L.marker [state.lat, state.lng],
            icon: new L.DivIcon
              html: '<div class="mapCluster"><span class="resultnumber">' + state.count + '</span></div>'
              className: 'dot more-results'
              iconSize: new L.Point 20, 20
          point.data = state
          statesPoints.push point
      markerCluster = new L.MarkerClusterGroup
        iconCreateFunction: (cluster) ->
          totalCount = 0
          $.each cluster.getAllChildMarkers(), (i,point)->
            totalCount += point.data.count if point.data.count
          new L.DivIcon({html: '<div class="mapCluster"><span class="resultnumber">' + totalCount + '</span></div>', className: 'dot more-results', iconSize: new L.Point(20, 20)})
        spiderfyOnMaxZoom: false
        showCoverageOnHover: false
        zoomToBoundsOnClick: false
      markerCluster.addLayers statesPoints
      this._layers.state = markerCluster
    this._layers.state

  getPointsLayer: ->
    unless this._layers.points
      markerCluster = new L.MarkerClusterGroup
        iconCreateFunction: (cluster) ->
          totalCount = cluster.getChildCount()
          new L.DivIcon({html: '<div class="mapCluster"><span class="resultnumber">' + totalCount + '</span></div>', className: 'dot more-results', iconSize: new L.Point(20, 20)})
        spiderfyOnMaxZoom: false
        showCoverageOnHover: false
        zoomToBoundsOnClick: false
      this._layers.points = markerCluster
    this._layers.points

  onDragend: ->
    this.loadMarkers()

  onZoomend: ->
    this.loadMarkers()

  getPosition: ->
    center    = this.map.getCenter()
    northEast = this.map.getBounds().getNorthEast()
    lat: center.lat
    lng: center.lng
    radius: center.distanceTo(northEast) / 1000

  requestItems: (position)->
    while this._requestsPool.length > 0
      this._requestsPool.shift().abort()

    t = this
    this._requestsPool.push $.ajax
      url: window.api_path
      data:
        'aggregatedCHO.spatial.coordinates': "#{position.lat},#{position.lng}"
        'aggregatedCHO.spatial.distance': "#{position.radius}km"
      dataType: 'jsonp'
      cache: true
      success: (data)->
        if $.isPlainObject(data) and $.isArray(data.docs)
          t.drawPoints data.docs

  drawPoints: (docs)->
    t = this
    toDraw = []
    $.each docs, (i, doc)->
      unless t._drawedItems[doc.id]
        t._drawedItems[doc.id] = true
        try
          coordinates = doc['aggregatedCHO.spatial.coordinates'][0].split ','
          point =
            id: doc.id
            title: doc['aggregatedCHO.title']
            thumbnail: doc['object.@id']
            lat: coordinates.shift()
            lng: coordinates.shift()
        catch error
        myIcon = L.divIcon({className: 'dot'})
        marker = new L.marker([point.lat, point.lng], {icon: myIcon})
        marker.data = point
        toDraw.push marker

    t.getPointsLayer().addLayers toDraw

  loadMarkers: ->
    stateLayer  = this.getStateLayer()
    pointsLayer = this.getPointsLayer()
    switch
      when this.map.getZoom() in [4..6]
        this.map.removeLayer pointsLayer
        this.map.addLayer    stateLayer
      else
        this.requestItems(this.getPosition())
        this.map.removeLayer stateLayer
        this.map.addLayer    pointsLayer
