(function() {
  this['GMap'] = (function($) {
    var dataKey, getData, hasData, map, mapOptionKeys, mapOptionsForElement, mergeDataOptions;
    map = {};
    mapOptionKeys = ["zoom", "title"];
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
      spacer != null ? spacer : spacer = "";
      return "data-" + spacer + key;
    };
    hasData = function(e, key, spacer) {
      return e.is("[" + (dataKey(key, spacer)) + "]");
    };
    getData = function(e, key, spacer) {
      return e.attr(dataKey(key, spacer));
    };
    mergeDataOptions = function(element, options, keys, spacer) {
      var key, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        _results.push(hasData(element, key, spacer) ? options[key] = getData(element, key, spacer) : void 0);
      }
      return _results;
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
    map.locationDataForMap = function($e) {
      return map.locationDataFromDataAttributes($e);
    };
    map.locationDataFromDataAttributes = function($e) {
      var result;
      return result = {
        id: $e.attr("id") || ("" + map.autoIDPrefix + (map.count++)),
        lat: +getData($e, "latitude"),
        lng: +getData($e, "longitude"),
        title: getData($e, 'marker-title')
      };
    };
    map.setupElement = function(e) {
      var $e, currentMap, location, mapOptions, marker, markerOptions, point;
      $e = $(e);
      location = map.locationDataForMap($e);
      point = new google.maps.LatLng(location.lat, location.lng);
      mapOptions = mapOptionsForElement($e);
      mapOptions.center = point;
      $e.empty().addClass('dynamic-google-map').removeClass('static-google-map');
      currentMap = new google.maps.Map(e, mapOptions);
      map.maps.push(currentMap);
      markerOptions = {
        position: point,
        map: currentMap,
        title: location.title
      };
      marker = new google.maps.Marker(markerOptions);
      return currentMap;
    };
    $(document).ready(function() {
      return map.install();
    });
    return map;
  })(jQuery);
}).call(this);
