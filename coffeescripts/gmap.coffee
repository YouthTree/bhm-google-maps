# GMap is a simply, unobtrusive google map adder for jQuery + HTML5.
# It uses data attributes to store map locations, works with a rails
# plugin to generate static alternatives and most importantly is simple.
@['GMap'] = (($) ->
  
  # The actual object we'll be exporting.
  map = {}
  
  # Map and marker options to autoextract.
  mapOptionKeys    = ["zoom", "title"]
  #markerOptionKeys = ["title"] 
  
  # Exposed options / data.
  map.count          = 0
  map.autoIDPrefix   = "gmap-"
  map.maps           = []
  
  # Use a function for the roadmap value to avoid load order issues.
  # e.g. if the google maps library is loaded after this one.
  map.defaultOptions =
    zoom:        15
    mapTypeId:   -> google.maps.MapTypeId.ROADMAP
    scrollwheel: false
  
  # Very, very simple wrapper for generating a data key - tbh possibly un-needed.
  dataKey = (key, spacer) ->
    spacer?= ""
    "data-#{spacer}#{key}"
    
  # Returns true iff the given element has the set data element, false otherwise.
  hasData = (e, key, spacer) ->
    e.is "[#{dataKey key, spacer}]"
    
  # Return the value of a given data attribute.
  getData = (e, key, spacer) ->
    e.attr dataKey(key, spacer)
  
  # Merges a given object w/ values retrieved using data element.
  # automatically namespaces keys etc.
  mergeDataOptions = (element, options, keys, spacer) ->
    for key in keys
      options[key] = getData(element, key, spacer) if hasData(element, key, spacer)
  
  # Return the map options for a given element.
  mapOptionsForElement = (element) ->
    options = $.extend {}, map.defaultOptions
    # Set the mapTypeId if it's a function
    options.mapTypeId = options.mapTypeId() if $.isFunction(options.mapTypeId)
    mergeDataOptions  element, options, mapOptionKeys
    options
  
  # Install the google map onto each option with the .gmap key.
  map.install = ->
    $('.gmap').each -> map.setupElement this

  # Return location data for a given map
  # Looks at `data-` on the element to determine where location data is
  #
  # Use `data-locations-selector` to contain a css selector that cooresponds 
  # to elements that contain the data (see `locationsDataFromElements`).
  #
  # Set `data-longitude` and `data-latitude` on the map directly element
  map.locationDataForMap = ($e) ->
    longitude = getData($e, 'longitude')
    if selector = getData($e, 'locations-selector')
      locations = map.locationsDataFromElements(selector)
    else if longitude.indexOf(',') > -1 # multiple locations
      locations = map.locationsDataFromDataAttributes($e)
    else if longitude
      locations = map.locationDataFromDataAttributes($e)
    else
      throw "dont have any map location data"
    # Add gmap point object to each location
    for loc in locations
      loc.point = new google.maps.LatLng(loc.lat, loc.lng) 
    locations

  # Default strategy to fetch location data, 
  # Get a single location's data from element's `data-` attributes
  map.locationDataFromDataAttributes = ($e) ->
    [map.readDataAttributes($e)]

  # Get Multiple locations embedded in `data-` attributes like:
  #     data-latitude="15,20.99" data-longitude="99.9,40.72"
  map.locationsDataFromDataAttributes = ($e) ->
    attrs = map.readDataAttributes($e)
    lats = attrs.lat.split ', '
    lngs = attrs.lng.split ', '
    result = for lat, i in lats
      {lat: lat, lng: lngs[i]}
    
  map.readDataAttributes = ($e) ->
    result = 
      id: $e.attr("id") || "#{map.autoIDPrefix}#{map.count++}"
      lat: getData($e, "latitude")
      lng: getData($e, "longitude")
      title: getData($e, 'marker-title')
    

  # Fetch location data from markup
  # Kinda based on hcard/geo 
  # http://microformats.org/wiki/hcard#Live_example
  # http://microformats.org/wiki/geo
  map.locationsDataFromElements = (selector) -> 
    $(selector).map ->
      result =
        lat: +$('.latitude', this).text()
        lng: +$('.longitude', this).text()
        title: $('.marker-title', this).text()

  # Called with a single html dom element as an argument, will
  # automatically set it up as a google map.
  map.setupElement = (e) ->
    $e = $ e
    # Get locations data 
    locations = map.locationDataForMap($e)
    # Start setting up the map / create a map element.
    mapOptions = mapOptionsForElement $e
    mapOptions.center = locations[0].point
    # Remove static map.
    $e.empty().addClass('dynamic-google-map').removeClass('static-google-map')
    # Make dynamic map.
    currentMap = new google.maps.Map e, mapOptions
    map.setLocations locations, currentMap
    # Store map reference
    map.maps.push currentMap
    currentMap
  
  # Places the location markers on the map
  # Sets the map bounds so they are all visible
  map.setLocations = (locations, _map) ->
    map.addLocationsToMap(locations, _map)
    bounds = map.boundsFor(locations)
    _map.fitBounds(bounds)

  # Returns a `LatLngBounds` object that contains
  # the given locations
  map.boundsFor = (locations) ->
    bounds = new google.maps.LatLngBounds
    bounds.extend(loc.point) for loc in locations
    bounds

  # Adds one or an array of locations to the map
  map.addLocationsToMap = (locations, _map) ->
    map.addLocationToMap(loc, _map) for loc in $.makeArray(locations) 

  # Adds one location to the map
  map.addLocationToMap = (location, _map) ->
    new google.maps.Marker 
      map:      _map
      position: location.point
      title:    location.title

  # On load, we'll install the maps.
  $(document).ready map.install
  
  # Return map to set it up.
  map
  
)(jQuery)
