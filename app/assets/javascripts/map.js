$(window).load(function() {

    var mapT;
    var markerList;
    var markers;
    var points;


    // if you want custom markers and clusters, set flag on true 
    var customizeMarkers = false;
    var customizeMarkerClusters = false;

    // we can close all popups in ZoomChange
    var popupsForClosing = []; //maybe deleted

     // FUNCTIONS
    var addHeaderToPopup = function (htmlPopup){
        
        var localHtmlPopup = htmlPopup;
        // htmlLocalClusterPopup += '<div class="mapBox">';
        localHtmlPopup += '<div class="boxInner">';
        localHtmlPopup += '<h5>Boston, MA</h5>';
        //htmlLocalClusterPopup += '<a class="closePopUp" href="">&times;</a>';
        localHtmlPopup += '<div class="box-rows">';

        return localHtmlPopup;
        
       
    };

    var addRowToPopup = function(data, htmlPopup) {

        var localHtmlPopup = htmlPopup;
        localHtmlPopup += '<div class="box-row">';
        localHtmlPopup += '<div class="box-right"><img src="' + data.image + '" alt="pop image" /></div>';
        localHtmlPopup += '<div class="box-left">';
        localHtmlPopup += '<h6>' + data.text + '</h6>';
        localHtmlPopup += '<h4><a href="">' + data.href + '</a></h4>';
        localHtmlPopup += '<p><span>' + data.author + '</span></p>';
        localHtmlPopup += '<a class="ViewObject" href="">View Object <span class="icon-view-object" aria-hidden="true"></span></a>';
        localHtmlPopup += '</div>';
        localHtmlPopup += '</div>';

        return localHtmlPopup;
    };

    var addFooterToPopup = function(htmlPopup) {
        
        var localHtmlPopup = htmlPopup;
        localHtmlPopup += ' </div> </div> </div>';
        return localHtmlPopup;
        
    };

    // EVENT LISTENERS

    var onMarkerClick = function(htmlPopup) {

        return function(e) {
            //e.target.openPopup();
            var popup = new L.popup();
            popup
                    .setLatLng(e.target.getLatLng())
                    .setContent(htmlPopup)
                    .openOn(mapT);
        };
    };

    function onClusterClick(a) {

        var localClusterMarkers = a.layer.getAllChildMarkers();



        localClusterMarkers.sort(function(a, b)
        {
            return b.dataT.score - a.dataT.score;
        });


        var htmlLocalClusterPopup = '';
        
        htmlLocalClusterPopup = addHeaderToPopup(htmlLocalClusterPopup);
        
        var numberOfRows = Math.min(localClusterMarkers.length, settings.numberOfBestResults);
        for (var i = 0; i < numberOfRows; i++) {

            var data = localClusterMarkers[i].dataT;

            htmlLocalClusterPopup = addRowToPopup(data, htmlLocalClusterPopup);

        }
        htmlLocalClusterPopup = addFooterToPopup(htmlLocalClusterPopup);
                
                

        var popupCluster = new L.popup();

        popupCluster
                .setLatLng(a.layer.getLatLng())
                .setContent(htmlLocalClusterPopup)
                .openOn(mapT);
        
        
        popupCluster.isCluster = true; //maybe deleted
        
        // ++ DEBUG
        console.log('cluster ' + localClusterMarkers.length);
        // -- DEBUG
        
        
        popupsForClosing.push(popupCluster); //maybe deleted
    }

    function onMapMoveEnd() {
        console.log(" Bounds of map " + mapT.getBounds().toBBoxString());
        // do query for getting new settings    
    }

    function onMapZoomEnd(e) {
        e.target.closePopup();
        // close all markerCluster popups, when you zooming //maybe deleted
        /* for (var i = 0; i < popupsForClosing.length; i++) {
         popupsForClosing[i].closePopup();
         }*/
    }


    // MAIN SECTION

    // Map initialization 
    mapT = L.map('mapT').setView([51.505, -0.09], 13);
    L.tileLayer('http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
        maxZoom: 18
    }).addTo(mapT);

    mapT.on('moveend', onMapMoveEnd);
    mapT.on('zoomend', onMapZoomEnd);


    // Draw markers

    points = settings.points;
    markerList = [];

    // ++ Debug
    console.log('start creating markers: ' + window.performance.now());
    // -- Debug


    for (var i = 0; i < points.length; i++) {
        var pointData = points[i];
        
        
        var htmlPopup = ''; 
        
        
        htmlPopup = addHeaderToPopup(htmlPopup);
        
        htmlPopup = addRowToPopup(pointData, htmlPopup);
        htmlPopup = addFooterToPopup(htmlPopup);

        if (customizeMarkers) {
            var myIcon = L.divIcon({className: 'dot'});

            var marker = new L.marker([points[i].lat, points[i].lon], {icon: myIcon}).addTo(mapT)
                    .bindPopup(htmlPopup);

        } else {

            var marker = new L.marker([points[i].lat, points[i].lon]).addTo(mapT)
                    .bindPopup(htmlPopup);


        }

        // link on data for view
        marker.dataT = pointData;

        marker.on('click', onMarkerClick(htmlPopup));

        markerList.push(marker);
    }



    // Marker Cluster initialization
    

    if (customizeMarkerClusters) {
        // var htmlMarkerCluster = '<div class="dot more-results""><span class="resultnumber">' + 785 + '</span>';

        markers = new L.MarkerClusterGroup({
            iconCreateFunction: function(cluster) {

                var childCount = cluster.getChildCount();
                return new L.DivIcon({html: '<div><span class="resultnumber">' + childCount + '</span></div>', className: 'dot more-results', iconSize: new L.Point(20, 20)});

            },
            spiderfyOnMaxZoom: false, showCoverageOnHover: false, zoomToBoundsOnClick: false});

        //markers.bindPopup(htmlMarkerCluster);
    } else {
        markers = new L.MarkerClusterGroup({spiderfyOnMaxZoom: false, showCoverageOnHover: false, zoomToBoundsOnClick: false});
    }

    markers.on('clusterclick', onClusterClick);


    // ++ Debug
    console.log('start clustering: ' + window.performance.now());
    // -- Debug



    // Draw marker clusters
    markers.addLayers(markerList);
    mapT.addLayer(markers);


    // ++ Debug
    console.log('end clustering: ' + window.performance.now());

    console.log(" Bounds of map " + mapT.getBounds().toBBoxString());

    // -- Debug
    
    
    
    
    
   
});
