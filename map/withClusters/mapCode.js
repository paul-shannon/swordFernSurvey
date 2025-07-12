import { MarkerClusterer} from "https://cdn.skypack.dev/@googlemaps/markerclusterer@2.0.3";

var iNatMarkers = [];
var uwMarkers = [];

//--------------------------------------------------------------------------------
// a button with no associated actions
function createToggleButtonsLabel(map)
{
   const labelButton = document.createElement("button");

   labelButton.style.backgroundColor = "#ccc";
   labelButton.style.border = "2px solid #fff";
   labelButton.style.borderRadius = "3px";
   labelButton.style.boxShadow = "0 2px 6px rgba(0,0,0,.3)";
   labelButton.style.color = "rgb(25,25,25)";
   labelButton.style.cursor = "pointer";
   labelButton.style.fontFamily = "Roboto,Arial,sans-serif";
   labelButton.style.fontSize = "16px";
   labelButton.style.lineHeight = "38px";
   labelButton.style.margin = "8px 0 22px";
   labelButton.style.padding = "0 5px";
   labelButton.style.textAlign = "center";
   labelButton.textContent = "Toggle: ";
   labelButton.type = "button";

   return labelButton;

} // createToggleButtonsLabel
//------------------------------------------------------------
function createINatMarkersToggle(map) {
  const controlButton = document.createElement("button");

  // Set CSS for the control.
  controlButton.style.backgroundColor = "#fff";
  controlButton.style.border = "2px solid #fff";
  controlButton.style.borderRadius = "3px";
  controlButton.style.boxShadow = "0 2px 6px rgba(0,0,0,.3)";
  controlButton.style.color = "rgb(25,25,25)";
  controlButton.style.cursor = "pointer";
  controlButton.style.fontFamily = "Roboto,Arial,sans-serif";
  controlButton.style.fontSize = "16px";
  controlButton.style.lineHeight = "38px";
  controlButton.style.margin = "8px 0 22px";
  controlButton.style.padding = "0 5px";
  controlButton.style.textAlign = "center";
  controlButton.textContent = "iNaturalist Reports";
  controlButton.type = "button";
  controlButton.addEventListener("click", () => {
      if(iNatMarkers[0].map == null){
         iNatMarkers.forEach(function(m) {m.map = map;})
         }
      else{
         iNatMarkers.forEach(function(m) {m.map = null;})
         }
     });
  return controlButton;
  }
//--------------------------------------------------------------------------------
function createToggleButtons(map)
{
   const centerControlDiv = document.createElement("div");
   const label = createToggleButtonsLabel()
   centerControlDiv.appendChild(label)
   window.centerControlDiv = centerControlDiv    

   const inatMarkersToggleButton = createINatMarkersToggle(map);
   centerControlDiv.appendChild(inatMarkersToggleButton)

   //const uwMarkersToggleButton = createUWMarkersToggle(map);
   //centerControlDiv.appendChild(uwMarkersToggleButton)

   map.controls[google.maps.ControlPosition.TOP_CENTER].push(centerControlDiv);

} // createToggleButtons
//--------------------------------------------------------------------------------
async function readINaturalistData()
{
   let inatReports;

   console.log("entering readINaturalistData")

   $.getJSON( "inatReports.json", function(json) {
       inatReports = json
       })
   .done(function(){
      console.log("getJSON done")
      console.log("iNat site count: " + inatReports.length)
      window.inatReports = inatReports
      })
   .fail(function(){
      console.log("getJSON failure with inatReports.json")
      })

   return(inatReports)

} // readINaturalistData
//--------------------------------------------------------------------------------
function createInaturalistMarkers(map, reports)
{
  console.log("--- createInaturalistMarkers")
  console.log("inat reports: " + reports.length)

  let options = google.maps.marker.PinElementOptions
  const pinBlue = new google.maps.marker.PinElement({ background: "#0000FF" });    
  let pin = new google.maps.marker.PinElement({
      scale: 0.5,
      background: '#FBBC04'
      });

  reports.forEach(function(report){
      var iNatLayer = new google.maps.Data()
      iNatLayer.setMap(map);
      window.iNatLayer = iNatLayer;
      var size = 5; 
      const pinRed = new google.maps.marker.PinElement({
           background: "#FF0000",
           scale: 0.75});    
      const marker = new google.maps.marker.AdvancedMarkerElement({
          position: {lat:  report["lat"], lng: report["lon"]},
          //map: null,
          //title: report["siteName"],
          //content: pinRed.element,
          //gmpClickable: true
          })
      let infoHTML =  "<h4> fern observation</h4>" +
             "<ul>" +
               "<li> by: " + report["user"] +
               "<li> date: " + report["date"] +
               "</ul>" +
               "<p>" + 
          report["description"] +
          "<br>" + 
          "<img src='" + report["url"] + "'>"
      //console.log("description: " + report["description"])
      let infoWindow = new google.maps.InfoWindow();
      marker.addListener("click", ({ domEvent, latLng }) => {
         const {target} = domEvent;
         infoWindow.close();
         infoWindow.setContent(infoHTML);
         //infoWindow.setContent(marker.title);
         infoWindow.open(map, marker);
         });
      iNatMarkers.push(marker)
      }) // forEach

} // createInaturalistMarkers
//------------------------------------------------------------
async function initMap() {
  const {Map} = await google.maps.importLibrary("maps");
  const {AdvancedMarkerElement, PinElement, InfoWindow} =
          await google.maps.importLibrary("marker");
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 7,
    center: {lat: 47.2277, lng: -122.3555},
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    mapId: "DEMO_MAP_ID"
    });

  map.addListener("click", (mapsMouseEvent) => {
     console.log(JSON.stringify(mapsMouseEvent.latLng.toJSON(), null, 2))
     });

  const infoWindow = new google.maps.InfoWindow({
    content: "",
    disableAutoPan: true,
    });
  const labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  const markers = locations.map((position, i) => {
    const label = labels[i % labels.length];
    console.log(" creating marker at ")
    console.log(position)
      
    const pinGlyph = new google.maps.marker.PinElement({
      glyph: label,
      glyphColor: "white",
      });
    const marker = new google.maps.marker.AdvancedMarkerElement({
      position,
      //content: pinGlyph.element,
      });

    marker.addListener("click", () => {
      infoWindow.setContent(position.lat + ", " + position.lng);
      infoWindow.open(map, marker);
      });
    return marker;
    });

   window.markers = markers
   const inatReports = await readINaturalistData()
   console.log("--- inatReports length:" + window.inatReports.length)
   createInaturalistMarkers(map, window.inatReports)
   let allMarkers = markers.concat(iNatMarkers)
   console.log("iNatMarkers: " + iNatMarkers.length)
   console.log("allMarkers: " + allMarkers.length)
   new markerClusterer.MarkerClusterer({iNatMarkers, map});
   createToggleButtons(map);
   console.log("leaving initMap")
    
} // initMap
//--------------------------------------------------------------------------------
const locations = [
    {"lat": 48.036296450920695, "lng": -121.97886959418624},
    {"lat": 47.60155710795051,  "lng": -122.32953821868786}
    ];

initMap();

$(document).ready(function(){
  console.log("document ready, reading inat data")
 readINaturalistData()
  //createInaturalistMarkers(map); // , inatReports)
  });

