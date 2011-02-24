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
      var loc, locations, selector, _i, _len;
      if (selector = getData($e, 'locations-selector')) {
        locations = map.locationsDataFromElements(selector);
      } else if (hasData($e, 'data-longitude')) {
        locations = map.locationsDataFromDataAttributes($e);
      } else {
        throw "dont have any map location data";
      }
      for (_i = 0, _len = locations.length; _i < _len; _i++) {
        loc = locations[_i];
        loc.point = new google.maps.LatLng(loc.lat, loc.lng);
      }
      return locations;
    };
    map.locationsDataFromDataAttributes = function($e) {
      return [
        {
          id: $e.attr("id") || ("" + map.autoIDPrefix + (map.count++)),
          lat: +getData($e, "latitude"),
          lng: +getData($e, "longitude"),
          title: getData($e, 'marker-title')
        }
      ];
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
    map.setupElement = function(e) {
      var $e, currentMap, locations, mapOptions;
      $e = $(e);
      locations = map.locationDataForMap($e);
      mapOptions = mapOptionsForElement($e);
      mapOptions.center = locations[0].point;
      $e.empty().addClass('dynamic-google-map').removeClass('static-google-map');
      currentMap = new google.maps.Map(e, mapOptions);
      map.setLocations(locations, currentMap);
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
