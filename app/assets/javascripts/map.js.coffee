$(document).ready ->
  numberOfBestResults = 3
  # markerList = []
  # markers = []
  # points = []
  # 

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
    # htmlLocalClusterPopup += '<div class="mapBox">'
    localHtmlPopup += '<div class="boxInner">'
    localHtmlPopup += '<h5>Boston, MA</h5>'
    # htmlLocalClusterPopup += '<a class="closePopUp" href="">&times;</a>'
    localHtmlPopup += '<div class="box-rows">'
    localHtmlPopup

  addRowToPopup = (data, htmlPopup) ->
    localHtmlPopup = htmlPopup
    localHtmlPopup += '<div class="box-row">'
    localHtmlPopup += '<div class="box-right"><img src="' + data.image + '" alt="pop image" /></div>'
    localHtmlPopup += '<div class="box-left">'
    localHtmlPopup += '<h6>' + data.text + '</h6>'
    localHtmlPopup += '<h4><a href="">' + data.href + '</a></h4>'
    localHtmlPopup += '<p><span>' + data.author + '</span></p>'
    localHtmlPopup += '<a class="ViewObject" href="">View Object <span class="icon-view-object" aria-hidden="true"></span></a>'
    localHtmlPopup += '</div>'
    localHtmlPopup += '</div>'
    localHtmlPopup

  addFooterToPopup = (htmlPopup) ->
    localHtmlPopup = htmlPopup
    localHtmlPopup += ' </div> </div> </div>'
    localHtmlPopup

  # EVENT LISTENERS
  onMarkerClick = (htmlPopup) ->
    (e) ->
      #e.target.openPopup()
      popup = new L.popup()
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
  
    popupCluster = new L.popup()
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
    url = '/map/items_by_spatial.js?lat='+map.getCenter().lat+"&lon="+map.getCenter().lng+"&radius="+getMapRadius()
    $.getScript(url, ->
      # clearMarkers
      markerList = drawMarkers()
      clusterizeMarkers markerList
    )
    
  # clearMarkers = ->
  #   mapT.removeLayer markers
    
  # Draw markers
  drawMarkers = ->
    points = settings.points
    markerList = []

    console.log('start creating markers: ' + window.performance.now())

    for point in points
      htmlPopup = ''
      htmlPopup = addHeaderToPopup htmlPopup
      htmlPopup = addRowToPopup    point, htmlPopup
      htmlPopup = addFooterToPopup htmlPopup

      if customizeMarkers
        myIcon = L.divIcon({className: 'dot'})
        marker = new L.marker([point.lat, point.lon], {icon: myIcon}).bindPopup(htmlPopup)
      else
        marker = new L.marker([point.lat, point.lon]).bindPopup(htmlPopup)

      # link on data for view
      marker.dataT = point
      marker.on 'click', onMarkerClick(htmlPopup)
      markerList.push marker
    markerList

  clusterizeMarkers = (markerList) ->
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
     
    console.log('start clustering: ' + window.performance.now())

    # Draw marker clusters
    markers.addLayers markerList
    markers.addTo map

    console.log('end clustering: ' + window.performance.now())
    console.log(" Bounds of map " + map.getBounds().toBBoxString())
    

  # Map initialization

  mapUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png'
  mapAttribution = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'

  minimal = L.tileLayer(mapUrl, 
    attribution: mapAttribution
    maxZoom: 18
  )

  markers = L.layerGroup()

  map = L.map('mapT',
    center: new L.LatLng(45.0, -93)
    zoom: 3
    layers: [minimal, markers]
  )

  map.on 'moveend', onMapMoveEnd
  map.on 'zoomend', onMapZoomEnd

  loadItems()