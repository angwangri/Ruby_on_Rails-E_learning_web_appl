// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require jquery.ui.autocomplete
//= require twitter/bootstrap
// require turbolinks
//= require underscore
//= require gmaps/google
//= require Gmaps
//= google_autocomplete
//= require rails-timeago
// require rails-timeago-all
//= require locales/jquery.timeago.zh-CN.js
//= require_tree .


function initMap(p0,p1){
  createMap(p0,p1);
  setMapEvent();
  addMapControl();
  // addMarker(p0,p1);
}
    
function createMap(p0,p1){
  var map = new BMap.Map("map");
  var point = new BMap.Point(p0,p1);
  map.centerAndZoom(point,16);
  window.map = map;
}
    
function setMapEvent(){
  map.enableDragging();
  map.enableScrollWheelZoom();
  map.enableDoubleClickZoom();
  map.enableKeyboard();
}
    
    
function addMapControl(){
  var ctrl_nav = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_ZOOM});
  map.addControl(ctrl_nav);
        
  var ctrl_ove = new BMap.OverviewMapControl({anchor:BMAP_ANCHOR_BOTTOM_RIGHT,isOpen:1});
  map.addControl(ctrl_ove);
      
  var ctrl_sca = new BMap.ScaleControl({anchor:BMAP_ANCHOR_BOTTOM_RIGHT});
  map.addControl(ctrl_sca);
}
    
    
  //The marking point array of latitude and longitude
  var markerArr = [{ title: "Tiananmen", content: "East Chang'an Avenue", point: "121.47370|31.23041", isOpen: 0, icon: { w: 23, h: 25, l: 0, t: 21, x: 9, lb: 12} }
];
//Create marker
function addMarker(p0,p1,fullname,availability,price,gravatar,link, availability_text, price_text,readmore_text,featured) {
  availability_text = (typeof availability_text === "undefined") ? "Availability" : availability_text;
  price_text = (typeof price_text === "undefined") ? "Price" : price_text;
  readmore_text = (typeof readmore_text === "undefined") ? "Price" : readmore_text;
  featured = (typeof featured === "undefined") ? false : true;

  for (var i = 0; i <markerArr.length; i++) {
    var json = markerArr[i];
    var point = new BMap.Point(p0, p1);
    var iconImg = createIcon(json.icon);
    var marker = new BMap.Marker(point, { icon: iconImg });
    var iw = createInfoWindow(fullname,availability,price, gravatar,link,availability_text,price_text,readmore_text,featured);
    var label = new BMap.Label(fullname, { "offset": new BMap.Size(12 - 9 + 10, -20) });
    marker.setLabel(label);
    map.addOverlay(marker);
    label.setStyle({
      borderColor: "#808080",
      color: "#333",
      cursor: "pointer"
    });

    (function () {
      var _iw = createInfoWindow(fullname,availability,price,gravatar,link, availability_text, price_text,readmore_text,featured);
      var _marker = marker;
      _marker.addEventListener("click", function () {
        this.openInfoWindow(_iw);
      });
      _iw.addEventListener("open", function () {
        _marker.getLabel().hide();
      })
      _iw.addEventListener("close", function () {
        _marker.getLabel().show();
      })
      label.addEventListener("click", function () {
        _marker.openInfoWindow(_iw);
      })
      if (!!json.isOpen) {
        label.hide();
        _marker.openInfoWindow(_iw);
      }
    })()
  }
}
//Create InfoWindow
function createInfoWindow(fullname,availability,price, gravatar,link,availability_text, price_text, readmore_text, featured) {
  featured_tutor = (featured == true) ? "<a class='lbOn featured' title='Featured Tutor' style='position: relative; left: 4px;' rel='featured' href='#myModal' data-toggle='modal' data-target='#myModal'><img src='/assets/vip.png' width='35'></a>" : ''
  var iw = new BMap.InfoWindow("<div style='z-index:99999;' class='gm-style-iw '><div style='overflow: auto;' class=''><div style='line-height:1.1em;margin-top:7px;'><b>"+fullname+"</b>"+featured_tutor+"</div><table cellpadding='0' cellspacing='0' border='0' style='margin-top:5px;width:100%;'><tbody><tr><td class='smaller_text' style='padding-right:5px;vertical-align:top;'><table><tbody><tr><td class='profileLeft2' style='width:56px;'>"+availability_text+": </td><td colspan='2'>&nbsp;"+availability+"</td></tr><tr><td class='profileLeft2' style='width:56px;'>"+price_text+": </td><td colspan='2'>"+ price +"</td></tr></tbody></table></td><td style='vertical-align:top;'><img src="+gravatar+" height='55' width='55' class='photo'></td></tr></tbody></table><center><a href='"+link+"' target='_blank'><b> "+readmore_text+"» </b></a></center></div></div>");
  return iw;
}
//Create a Icon
function createIcon(json) {
  console.log("in here");
  var icon = new BMap.Icon("/assets/blue_pointer.png", new BMap.Size(40, 40), { imageOffset: new BMap.Size(0,0), infoWindowOffset: new BMap.Size(json.lb + 5, 1), offset: new BMap.Size(0,0) })
  return icon;
}

$(function() {
  initMap();
});