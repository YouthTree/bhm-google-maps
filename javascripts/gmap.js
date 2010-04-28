var GMap;
// GMap is a simply, unobtrusive google map adder for jQuery + HTML5.
// It uses data attributes to store map locations, works with a rails
// plugin to generate static alternatives and most importantly is simple.
GMap = (function($) {
  var dataKey, getData, hasData, map, mapOptionKeys, mapOptionsForElement, markerOptionKeys, mergeDataOptions;
  // The actual object we'll be exporting.
  map = {};
  // Map and marker options to autoextract.
  mapOptionKeys = ["zoom", "title"];
  markerOptionKeys = ["title"];
  // Exposed options / data.
  map.count = 0;
  map.autoIDPrefix = "gmap-";
  map.maps = [];
  // Use a function for the roadmap value to avoid load order issues.
  // e.g. if the google maps library is loaded after this one.
  map.defaultOptions = {
    zoom: 15,
    mapTypeId: function mapTypeId() {
      return google.maps.MapTypeId.ROADMAP;
    },
    scrollwheel: false
  };
  // Very, very simple wrapper for generating a data key - tbh possibly un-needed.
  dataKey = function dataKey(key, spacer) {
    spacer = (typeof spacer !== "undefined" && spacer !== null) ? spacer : "";
    return "data-" + spacer + key;
  };
  // Returns true iff the given element has the set data element, false otherwise.
  hasData = function hasData(e, key, spacer) {
    return e.is(("[" + (dataKey(key, spacer)) + "]"));
  };
  // Return the value of a given data attribute.
  getData = function getData(e, key, spacer) {
    return e.attr(dataKey(key, spacer));
  };
  // Merges a given object w/ values retrieved using data element.
  // automatically namespaces keys etc.
  mergeDataOptions = function mergeDataOptions(element, options, keys, spacer) {
    var _a, _b, _c, _d, key;
    _a = []; _c = keys;
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      key = _c[_b];
      _a.push((function() {
        if (hasData(element, key, spacer)) {
          options[key] = getData(element, key, spacer);
          return options[key];
        }
      })());
    }
    return _a;
  };
  // Return the map options for a given element.
  mapOptionsForElement = function mapOptionsForElement(element) {
    var options;
    options = $.extend({}, map.defaultOptions);
    // Set the mapTypeId if it's a function
    if ($.isFunction(options.mapTypeId)) {
      options.mapTypeId = options.mapTypeId();
    }
    mergeDataOptions(element, options, mapOptionKeys);
    return options;
  };
  // Install the google map onto each option with the .gmap key.
  map.install = function install() {
    return $('.gmap').each(function() {
      return map.setupElement(this);
    });
  };
  // Called with a single html dom element as an argument, will
  // automatically set it up as a google map.
  map.setupElement = function setupElement(e) {
    var $e, currentMap, id, lat, lng, mapOptions, marker, markerOptions, point;
    $e = $(e);
    id = $e.attr("id");
    if (!((typeof id !== "undefined" && id !== null))) {
      $e.attr("id", ("" + (map.autoIDPrefix) + (map.count++)));
    }
    // Get the position of the current marker.
    lat = Number(getData($e, "latitude"));
    lng = Number(getData($e, "longitude"));
    point = new google.maps.LatLng(lat, lng);
    // Start setting up the map / create a map element.
    mapOptions = mapOptionsForElement($e);
    mapOptions.center = point;
    $e.empty().addClass('dynamic-google-map').removeClass('static-google-map');
    currentMap = new google.maps.Map(e, mapOptions);
    map.maps.push(currentMap);
    // Now, we need to finally add the marker to the map.
    markerOptions = {
      position: point,
      map: currentMap
    };
    mergeDataOptions($e, markerOptions, markerOptionKeys, "marker-");
    marker = new google.maps.Marker(markerOptions);
    return currentMap;
  };
  // On load, we'll install the maps.
  $(document).ready(function() {
    return map.install();
  });
  // Return map to set it up.
  return map;
})(jQuery);