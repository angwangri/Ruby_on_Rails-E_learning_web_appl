// function initializeMap(hash) {
//     var raw_markers   = hash;
//     var gmaps_markers;

//     function bindLiToMarker($li, marker){
//         $li.click(function(){
//                 marker.panTo(); //to pan to the marker
//                 google.maps.event.trigger(marker.getServiceObject(), "click"); // to open infowindow
//         });
//     };

//     function createSidebar(){

//         for (var i=0;i<raw_markers.length;i++){
//             var $link = $(".pointer-" + String.fromCharCode(i+65))
//             bindLiToMarker($link, gmaps_markers[i]);
//         }
//     };

//     handler = Gmaps.build('Google');
//             handler.buildMap({ provider: {zoom: 2}, internal: {id: 'map'}}, function(){
//             gmaps_markers = handler.addMarkers(raw_markers);
//             handler.bounds.extendWith(gmaps_markers);
//             handler.fitMapToBounds();
//                     createSidebar();
//             });

// };

// function initializeMiniMap(hash) {
//     var raw_markers   = hash;
//     var gmaps_markers;

//     handler = Gmaps.build('Google');
//             handler.buildMap({ provider: {zoom: 10}, internal: {id: 'map'}}, function(){
//             gmaps_markers = handler.addMarkers(raw_markers);
//             //handler.bounds.extendWith(gmaps_markers);
//             handler.fitMapToBounds();
//             handler.getMap().setCenter(new google.maps.LatLng(raw_markers[0].lat, raw_markers[0].lng));
//             });
// };



// function initializeMiniMapLocation(hash) {
//     var raw_markers = hash;
//     var gmaps_markers;
//     var geocoder;
//     geocoder = new google.maps.Geocoder();

//     handler = Gmaps.build('Google');
//             handler.buildMap({ provider: {zoom: 12}, internal: {id: 'map'}}, function(){
//             gmaps_markers = handler.addMarkers(raw_markers, {'draggable' : true});
//             //handler.bounds.extendWith(gmaps_markers);
//                                     // Listen to drag & drop
//             if(gmaps_markers[0] != undefined){
//                 google.maps.event.addListener(gmaps_markers[0].serviceObject, 'dragend', function() {
//                     updateFormLocation(this.getPosition());
//                 });
//             }

//             handler.fitMapToBounds();
//             handler.getMap().setCenter(new google.maps.LatLng(raw_markers[0].lat, raw_markers[0].lng));
//             });

//   function updateFormLocation(latlng) {
//     geocoder.geocode({'latLng': latlng}, function(results, status) {
//         if (status == google.maps.GeocoderStatus.OK) {
//           if (results[0]) {
//             for(var i=0; i < results[0].address_components.length; i++)
//                 {
//                     var component = results[0].address_components[i];
//                     if(component.types[0] == "locality")
//                     {
//                         $("#user_details_city").val(component.long_name)
//                     }
//                     if(component.types[0] == "administrative_area_level_1")
//                     {
//                        $("#user_details_state").val(component.long_name)
//                     }
//                     if(component.types[0] == "postal_code")
//                     {
//                        $("#user_details_zip_code").val(component.long_name)
//                     }
//                     if(component.types[0] == "country")
//                     {
//                         $("#user_details_country").val(component.long_name)
//                     }

//                 }
//           } else {
//             console.log('No results found');
//           }
//         } else {
//           console.log('Geocoder failed due to: ' + status);
//         }  
//         });
//     }
// }