$(document).ready ->
  wrapper = new MapWrapper('map')
  map = wrapper.map
  $('#toggle').on 'click', ->
    setTimeout ->
      map.invalidateSize()
    , 500

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
      markerCluster.on 'clusterclick', (cluster)->
        console.log cluster
      this._layers.state = markerCluster
    this._layers.state

  getPointsLayer: ->
    t = this
    unless this._layers.points
      markerCluster = new L.MarkerClusterGroup
        iconCreateFunction: (cluster) ->
          totalCount = cluster.getChildCount()
          new L.DivIcon({html: '<div class="mapCluster"><span class="resultnumber">' + totalCount + '</span></div>', className: 'dot more-results', iconSize: new L.Point(20, 20)})
        spiderfyOnMaxZoom: false
        showCoverageOnHover: false
        zoomToBoundsOnClick: false
      markerCluster.on 'clusterclick', (cluster)->
        points = cluster.layer.getAllChildMarkers()
        points = t.generatePopup(points.slice(0,5)).setLatLng(cluster.layer.getLatLng())
        points.openOn t.map
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
      beforeSend: ->
        t.turnWaitCursor true
      success: (data)->
        if $.isPlainObject(data) and $.isArray(data.docs)
          t.drawPoints data.docs
      complete: ->
        t.turnWaitCursor false

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
            type: doc['aggregatedCHO.type'] || ''
            creator: doc['aggregatedCHO.creator'] || ''
            url: doc['isShownAt.@id']
            lat: coordinates.shift()
            lng: coordinates.shift()
        catch error
        myIcon = L.divIcon({className: 'dot'})
        marker = new L.marker([point.lat, point.lng], {icon: myIcon})
        marker.data = point
        marker.on 'click', (e)->
          popup = t.generatePopup(e.target).setLatLng(e.target.getLatLng())
          popup.openOn t.map
        toDraw.push marker

    t.getPointsLayer().addLayers toDraw

  turnWaitCursor: (turn)->
    cursor = if turn then 'wait' else ''
    $(this.map.getContainer()).css(cursor: cursor)

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

  generatePopup: (points) ->
    points = [points] unless points instanceof Array

    html = ''
    $.each points, (i,point) ->
      point = point.data
      content =
        """
          <h6> #{ point.type }</h6>
          <h4><a href="/item/#{ point.id }">#{ point.title }</a></h4>
          <p><span> #{ point.creator }</span></p>
          <a class="ViewObject" href="#{ point.url }" target="_blank">View Object <span class="icon-view-object" aria-hidden="true"></span></a>
        """
      if point.thumbnail
        html +=
          """
            <div class="box-row">
              <div class="box-right"><img src="#{ point.thumbnail }" /></div>
              <div class="box-left">#{ content }</div>
            </div>
          """
      else
        html += "<div class=\"box-row\">#{ content }</div>"

    html = '<div class="box-rows">' + html + '</div>' if points.length > 1
    popup = new L.DPLAPopup offset: new L.Point(-10,-30)
    popup.setContent html


L.DPLAPopup = L.Popup.extend
  _initLayout: ->
    this._container = mapBox = L.DomUtil.create 'div', 'mapBox'
    closeButton = L.DomUtil.create 'a', 'closePopUp', mapBox
    closeButton.href = '#close'
    closeButton.innerHTML = '&#215;'
    L.DomEvent.on closeButton, 'click', this._onCloseButtonClick, this
    this._contentNode = L.DomUtil.create 'div', 'boxInner', mapBox
    L.DomEvent.on(this._contentNode, 'mousewheel', L.DomEvent.stopPropagation);
    this._tip = L.DomUtil.create('div', 'mapArrow', mapBox);
  _updateLayout: ->
    container = this._contentNode
    this._containerWidth = container.offsetWidth;
    container.style.height =  container.offsetHeight + 'px';
    this._container.style.bottom = 50 + 'px';
    this._container.style.left = 50 + 'px';
  _updatePosition: ->
    pos = this._map.latLngToLayerPoint(this._latlng)
    animated = this._animated
    offset = this.options.offset
    if (animated)
      L.DomUtil.setPosition(this._container, pos);
    this._containerBottom = -offset.y - (animated ? 0 : pos.y);
    this._containerLeft = -Math.round(this._containerWidth / 2) + offset.x + (animated ? 0 : pos.x);
    adjust =
      x: 20
      y: 10
    this._container.style.bottom = (this._containerBottom + adjust.y) + 'px';
    this._container.style.left = (this._containerLeft + adjust.x) + 'px';