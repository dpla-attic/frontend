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


# Generate popup for single point/list of points
#
generatePopup = (points) ->
  points = [points] unless points instanceof Array

  html = ''
  $.each points, (i,point) ->
    html +=
      """
        <div class="box-row">
          <div class="box-right">
            <img src="#{ point.image }" alt="pop image" />
          </div>
          <div class="box-left">
            <h6> #{ point.type }</h6>
            <h4><a href="">#{ point.title }</a></h4>
            <p><span> #{ point.creator }</span></p>
            <a class="ViewObject" href="">View Object <span class="icon-view-object" aria-hidden="true"></span></a>
          </div>
        </div>
      """
  html = '<div class="box-rows">' + html + '</div>' if points.length > 1
  popup = new L.DPLAPopup offset: new L.Point(-10,-30)
  popup.setContent html


$(document).ready ->
  numberOfBestResults = 5
  points = {}

  # we can close all popups in ZoomChange
  popupsForClosing = [] #maybe deleted

  # Return map radius in km (vector length from center to corner)
  getMapRadius = ->
    mapBoundNorthEast = map.getBounds().getNorthEast()
    mapDistance = mapBoundNorthEast.distanceTo(map.getCenter())
    mapDistance/1000

  # EVENT LISTENERS
  onMarkerClick = (point) ->
    (e) ->
      latLng = e.target.getLatLng()
      generatePopup(point).setLatLng(latLng).openOn(map)

  onClusterClick = (a) ->
    localClusterMarkers = a.layer.getAllChildMarkers()

    localClusterMarkers.sort (a, b) ->
      b.dataT.score - a.dataT.score

    points = $.map localClusterMarkers.slice(0, numberOfBestResults), (marker)->
      marker.dataT


    popupCluster = generatePopup(points)
    popupCluster.setLatLng(a.layer.getLatLng()).openOn(map)

    popupCluster.isCluster = true #maybe deleted

    popupsForClosing.push(popupCluster) #maybe deleted

  onMapMoveEnd = ->
    loadItems()

  onMapZoomEnd = (e) ->
    e.target.closePopup()
    false

  loadItems = ->
    lat = map.getCenter().lat
    lon = map.getCenter().lng
    url = "/map/items_by_spatial.js?lat=#{ lat }&lon=#{ lon }&radius=#{ getMapRadius() }"
    $.getScript(url, ->
      drawMarkers()
    )

  # Draw markers
  drawMarkers = ->
    toDraw = []
    $.each settings.points, (i,point) ->
      unless point.id of points
        toDraw.push point
        points[point.id] = point

    markersList = $.map toDraw, (point) ->
      myIcon = L.divIcon({className: 'dot'})
      marker = new L.marker([point.lat, point.lon], {icon: myIcon})
      marker.dataT = point
      marker.on 'click', onMarkerClick(point)
      marker

    markers.addLayers markersList

  # Map initialization
  mapUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  mapAttribution = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'

  minimal = L.tileLayer(mapUrl,
    attribution: mapAttribution
    maxZoom: 18
  )

  markers = new L.MarkerClusterGroup
    iconCreateFunction: (cluster) ->
      childCount = cluster.getChildCount()
      new L.DivIcon({html: '<div><span class="resultnumber">' + childCount + '</span></div>', className: 'dot more-results', iconSize: new L.Point(20, 20)})
    spiderfyOnMaxZoom: false, showCoverageOnHover: false, zoomToBoundsOnClick: false

  markers.on 'clusterclick', onClusterClick

  map = L.map('map',
    center: new L.LatLng(45.0, -93)
    zoom: 3
    layers: [minimal, markers]
  )

  map.on 'moveend', onMapMoveEnd
  map.on 'zoomend', onMapZoomEnd

  loadItems()