/*
 * notes
 * 47.560852, -122.251770
 * 47.558488, -122.251819
 * 47.560852 - 47.558488 =  0.002364
 * at 0001 = 36'
 * 23.26 * 36  = 837 feet
 * 837 * pi: 2360 sq feet
 */
//let map;
let mapCenter = {lat: 47.556114, lng: -122.253256};
var locationMarker;
var map;

function readPointData(){
  console.log("entering readPointData")
  $.getJSON( "ferns.json", function(json) {
      window.ferns = json
      })
   .done(function(){
      console.log("getJSON ferns done")
      console.log("fern count: " + window.ferns.length)
      map = initMap();
      })
   .fail(function(){
       console.log("getJSON failure")
       })

   } // readPointData

$(document).ready(function(){
  readPointData()
});

//--------------------------------------------------------------------------------
function printClickPoint(event){
   var lat = event.latLng["lat"]()
   var long = event.latLng["lng"]()
    console.log(lat.toFixed(6) + ", " + long.toFixed(6))
   }
//--------------------------------------------------------------------------------
async function initMap(){

  const {Map} = await google.maps.importLibrary("maps");

  const defaultFernMarker =  {path: google.maps.SymbolPath.CIRCLE,
                              fillColor: '#FFF',
                              fillOpacity: 0.6,
                              strokeColor: '#000',
                              strokeOpacity: 0.9,
                              strokeWeight: 1,
                              scale: 4
                              }

  map = new Map(document.getElementById("map"),
                {center: mapCenter,
                 zoom: 21
                });

        
  map.addListener("click", (mapsMouseEvent) => {
     printClickPoint(mapsMouseEvent);
     })
                  
    drawPoints(map)
    return(map)

} // initMap function
//--------------------------------------------------------------------------------
async function drawPoints(map){

  console.log("entering drawPoings, fern count: " + window.ferns.length)
  window.ferns.forEach(function(fern){
      var size = 8;
      var newColor = "gray";
      if(fern['status'] === "alive"){
         newColor = "lightgreen";
         }
      const icon = {path: google.maps.SymbolPath.CIRCLE,
                    scale: size,
                    fillOpacity: 1,
                    strokeWeight: 1,
                    fillColor: newColor,
                    strokeColor: '#000',
                    }
      let marker = new google.maps.Marker({
           position: {lat:  fern["lat"], lng: fern["lon"]},
           map,
           title: "another fern",
           icon: icon
           })
       }) // forEach
 
    // log center:    (47.5560358, -122.2532737)

       const tiltedRectangleCoords = [
           {lat: 47.556026, lng: -122.253214},
           {lat: 47.556136, lng: -122.253386},
           {lat: 47.556140, lng: -122.253379},
           {lat: 47.556029, lng: -122.253207}]


    const tiltedRectangle = new google.maps.Polygon({
        paths: tiltedRectangleCoords,
        strokeColor: 'brown', //'#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: 'brown', //'#FF0000',
        fillOpacity: 0.5
    });
    
    // Set the map for the polygon
    tiltedRectangle.setMap(map);
    

} // drawPoints
//--------------------------------------------------------------------------------
