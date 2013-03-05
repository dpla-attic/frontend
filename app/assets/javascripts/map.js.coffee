$(document).ready ->
  numberOfBestResults = 2
  points = []

  # if you want custom markers and clusters, set flag on true 
  customizeMarkers = false
  customizeMarkerClusters = false

  # we can close all popups in ZoomChange
  popupsForClosing = [] #maybe deleted
  
  # Return map radius in km (vector length from center to corner)
  getMapRadius = ->
    mapBoundNorthEast = map.getBounds().getNorthEast()
    mapDistance = mapBoundNorthEast.distanceTo(map.getCenter())
    mapDistance/1000
  
  addHeaderToPopup = (htmlPopup) ->
    localHtmlPopup = htmlPopup
    localHtmlPopup += """
                      <div class="boxInner">
                      <div class="box-rows">
                      """
    localHtmlPopup

  addRowToPopup = (data, htmlPopup) ->
    localHtmlPopup = htmlPopup
    localHtmlPopup += """
                      <div class="box-row">
                      <div class="box-right"><img src="#{ data.image }" alt="pop image" /></div>
                      <div class="box-left">
                      <h6> #{ data.type }</h6>
                      <h4><a href="">#{ data.title }</a></h4>
                      <p><span> #{ data.creator }</span></p>
                      <a class="ViewObject" href="">View Object <span class="icon-view-object" aria-hidden="true"></span></a>
                      </div>
                      </div>
                      """
    localHtmlPopup

  addFooterToPopup = (htmlPopup) ->
    localHtmlPopup = htmlPopup
    localHtmlPopup += ' </div> </div> </div>'
    localHtmlPopup

  # EVENT LISTENERS
  onMarkerClick = (htmlPopup) ->
    (e) ->
      #e.target.openPopup()
      popup = new L.popup(className: "mapBox", minWidth: 400, maxWidth: 400)
      popup.setLatLng(e.target.getLatLng()).setContent(htmlPopup).openOn(map)

  onClusterClick = (a) ->
    localClusterMarkers = a.layer.getAllChildMarkers()
  
    localClusterMarkers.sort (a, b) ->
      b.dataT.score - a.dataT.score
  
    htmlLocalClusterPopup = ''
    htmlLocalClusterPopup = addHeaderToPopup htmlLocalClusterPopup
        
    numberOfRows = Math.min localClusterMarkers.length, numberOfBestResults
    for localClusterMarker in localClusterMarkers[0...numberOfRows]
      htmlLocalClusterPopup = addRowToPopup localClusterMarker.dataT, htmlLocalClusterPopup
    
    htmlLocalClusterPopup = addFooterToPopup htmlLocalClusterPopup
  
    popupCluster = new L.popup(className: "mapBox", minWidth: 400, maxWidth: 400)
    popupCluster.setLatLng(a.layer.getLatLng()).setContent(htmlLocalClusterPopup).openOn(map)

    popupCluster.isCluster = true #maybe deleted
    
    console.log('cluster ' + localClusterMarkers.length)
    
    popupsForClosing.push(popupCluster) #maybe deleted

  onMapMoveEnd = ->
    console.log(" Bounds of map " + map.getBounds().toBBoxString())
    console.log(" Radius " + getMapRadius() + ", center: " + map.getCenter())
    loadItems()

  onMapZoomEnd = (e) ->
    e.target.closePopup()
    # close all markerCluster popups, when you zooming //maybe deleted
    #for (var i = 0; i < popupsForClosing.length; i++)
      #popupsForClosing[i].closePopup()
    false
    
  loadItems = ->
    lat = map.getCenter().lat
    lon = map.getCenter().lng
    url = "/map/items_by_spatial.js?lat=#{ lat }&lon=#{ lon }&radius=#{ getMapRadius() }"
    $.getScript(url, ->
      drawMarkers()
    )

  # Check if id of point contains in array
  contains = (point) ->
    for p in points
      return true if p.id == point.id
    false

  # Draw markers
  drawMarkers = ->
    # newPoints = (point for point in settings.points if contains(point, points))
    newPoints = []
    for point in settings.points
      newPoints.push(point) unless contains point
    points = points.concat newPoints # only new points

    markerList = []
    for point in newPoints
      htmlPopup = ''
      htmlPopup = addHeaderToPopup htmlPopup
      htmlPopup = addRowToPopup    point, htmlPopup
      htmlPopup = addFooterToPopup htmlPopup

      if customizeMarkers
        myIcon = L.divIcon({className: 'dot'})
        marker = new L.marker([point.lat, point.lon], {icon: myIcon})
      else
        marker = new L.marker([point.lat, point.lon])

      # marker.bindPopup(htmlPopup, {className: 'mapBox'})

      marker.dataT = point
      marker.on 'click', onMarkerClick(htmlPopup)
      markerList.push marker
    markers.addLayers markerList

  # Map initialization
  mapUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png'
  mapAttribution = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'

  minimal = L.tileLayer(mapUrl, 
    attribution: mapAttribution
    maxZoom: 18
  )

  if customizeMarkerClusters
    # var htmlMarkerCluster = '<div class="dot more-results""><span class="resultnumber">' + 785 + '</span>';
    markers = new L.MarkerClusterGroup
      iconCreateFunction: (cluster) ->
        childCount = cluster.getChildCount()
        new L.DivIcon({html: '<div><span class="resultnumber">' + childCount + '</span></div>', className: 'dot more-results', iconSize: new L.Point(20, 20)})
      spiderfyOnMaxZoom: false, showCoverageOnHover: false, zoomToBoundsOnClick: false
    # markers.bindPopup(htmlMarkerCluster);
  else
    markers = new L.MarkerClusterGroup(
      spiderfyOnMaxZoom:   false
      showCoverageOnHover: false
      zoomToBoundsOnClick: false
    )

  markers.on 'clusterclick', onClusterClick

  map = L.map('mapT',
    center: new L.LatLng(45.0, -93)
    zoom: 3
    layers: [minimal, markers]
  )

  map.on 'moveend', onMapMoveEnd
  map.on 'zoomend', onMapZoomEnd

  loadItems()