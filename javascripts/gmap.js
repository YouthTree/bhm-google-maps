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
      var loc, locations, longitude, selector, _i, _len;
      longitude = getData($e, 'longitude');
      if (selector = getData($e, 'locations-selector')) {
        locations = map.locationsDataFromElements(selector);
      } else if (longitude.indexOf(',') > -1) {
        locations = map.locationsDataFromDataAttributes($e);
      } else if (longitude) {
        locations = map.locationDataFromDataAttributes($e);
      } else {
        throw "dont have any map location data";
      }
      for (_i = 0, _len = locations.length; _i < _len; _i++) {
        loc = locations[_i];
        loc.point = new google.maps.LatLng(loc.lat, loc.lng);
      }
      return locations;
    };
    map.locationDataFromDataAttributes = function($e) {
      return [map.readDataAttributes($e)];
    };
    map.locationsDataFromDataAttributes = function($e) {
      var attrs, i, lat, lats, lngs, result;
      attrs = map.readDataAttributes($e);
      lats = attrs.lat.split(', ');
      lngs = attrs.lng.split(', ');
      return result = (function() {
        var _len, _results;
        _results = [];
        for (i = 0, _len = lats.length; i < _len; i++) {
          lat = lats[i];
          _results.push({
            lat: lat,
            lng: lngs[i]
          });
        }
        return _results;
      })();
    };
    map.readDataAttributes = function($e) {
      var result;
      return result = {
        id: $e.attr("id") || ("" + map.autoIDPrefix + (map.count++)),
        lat: getData($e, "latitude"),
        lng: getData($e, "longitude"),
        title: getData($e, 'marker-title')
      };
    };
    map.locationsDataFromElements = function(selector) {
      return $(selector).map(function() {
        var result;
        return result = {
          lat: +$('.latitude', this).text(),
          lng: +$('.longitude', this).text(),
          title: $('.marker-title', this).text()
        };
      });
    };
    map.setupElement = function(container) {
      var currentMap, dynamicMap, locations, mapOptions, staticMap;
      container = $(container).css('position', 'relative');
      staticMap = container.find('img:first').css({
        position: 'absolute',
        top: 0,
        'z-index': 9999
      });
      dynamicMap = $('<div class="dynamic-google-map" />').appendTo(container);
      locations = map.locationDataForMap(container);
      mapOptions = mapOptionsForElement(container);
      mapOptions.center = locations[0].point;
      currentMap = new google.maps.Map(dynamicMap[0], mapOptions);
      map.setLocations(locations, currentMap);
      google.maps.event.addListenerOnce(currentMap, 'tilesloaded', function() {
        container.removeClass('static-google-map');
        staticMap.remove();
        return dynamicMap.css('z-index', 'auto');
      });
      map.maps.push(currentMap);
      return currentMap;
    };
    map.setLocations = function(locations, _map) {
      var bounds;
      map.addLocationsToMap(locations, _map);
      bounds = map.boundsFor(locations);
      return _map.fitBounds(bounds);
    };
    map.boundsFor = function(locations) {
      var bounds, loc, _i, _len;
      bounds = new google.maps.LatLngBounds;
      for (_i = 0, _len = locations.length; _i < _len; _i++) {
        loc = locations[_i];
        bounds.extend(loc.point);
      }
      return bounds;
    };
    map.addLocationsToMap = function(locations, _map) {
      var loc, _i, _len, _ref, _results;
      _ref = $.makeArray(locations);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        loc = _ref[_i];
        _results.push(map.addLocationToMap(loc, _map));
      }
      return _results;
    };
    map.addLocationToMap = function(location, _map) {
      return new google.maps.Marker({
        map: _map,
        position: location.point,
        title: location.title
      });
    };
    $(document).ready(map.install);
    return map;
  })(jQuery);
}).call(this);
