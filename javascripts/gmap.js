this['GMap'] = (function($) {
  var dataKey, getData, hasData, map, mapOptionKeys, mapOptionsForElement, markerOptionKeys, mergeDataOptions;
  map = {};
  mapOptionKeys = ["zoom", "title"];
  markerOptionKeys = ["title"];
  map.count = 0;
  map.autoIDPrefix = "gmap-";
  map.maps = [];
  map.defaultOptions = {
    zoom: 15,
    mapTypeId: function() {
      return google.maps.MapTypeId.ROADMAP;
    },
    scrollwheel: false
  };
  dataKey = function(key, spacer) {
    spacer = (typeof spacer !== "undefined" && spacer !== null) ? spacer : "";
    return "data-" + (spacer) + (key);
  };
  hasData = function(e, key, spacer) {
    return e.is(("[" + (dataKey(key, spacer)) + "]"));
  };
  getData = function(e, key, spacer) {
    return e.attr(dataKey(key, spacer));
  };
  mergeDataOptions = function(element, options, keys, spacer) {
    var _a, _b, _c, _d, key;
    _a = []; _c = keys;
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      key = _c[_b];
      _a.push((function() {
        if (hasData(element, key, spacer)) {
          return (options[key] = getData(element, key, spacer));
        }
      })());
    }
    return _a;
  };
  mapOptionsForElement = function(element) {
    var options;
    options = $.extend({}, map.defaultOptions);
    if ($.isFunction(options.mapTypeId)) {
      options.mapTypeId = options.mapTypeId();
    }
    mergeDataOptions(element, options, mapOptionKeys);
    return options;
  };
  map.install = function() {
    return $('.gmap').each(function() {
      return map.setupElement(this);
    });
  };
  map.setupElement = function(e) {
    var $e, address, currentMap, id, lat, lng, mapOptions, marker, markerOptions, point;
    $e = $(e);
    id = $e.attr("id");
    if (!((typeof id !== "undefined" && id !== null))) {
      $e.attr("id", ("" + (map.autoIDPrefix) + (map.count++)));
    }
    if (hasData($e, "latitude" && hasData($e, "longitude"))) {
      lat = Number(getData($e, "latitude"));
      lng = Number(getData($e, "longitude"));
      map.drawLatLng($e, e, lat, lng);
    } else {
      address = getData($e, "address");
    }
    point = new google.maps.LatLng(lat, lng);
    mapOptions = mapOptionsForElement($e);
    mapOptions.center = point;
    $e.empty().addClass('dynamic-google-map').removeClass('static-google-map');
    currentMap = new google.maps.Map(e, mapOptions);
    map.maps.push(currentMap);
    markerOptions = {
      position: point,
      map: currentMap
    };
    mergeDataOptions($e, markerOptions, markerOptionKeys, "marker-");
    marker = new google.maps.Marker(markerOptions);
    return currentMap;
  };
  $(document).ready(function() {
    return map.install();
  });
  return map;
})(jQuery);