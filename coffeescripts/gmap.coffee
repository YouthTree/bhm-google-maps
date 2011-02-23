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
  map.locationDataForMap = ($e) ->
    map.locationDataFromDataAttributes($e)

  # Default strategy to fetch location data, 
  # Get a single location's data from element's `data-` attributes
  map.locationDataFromDataAttributes = ($e) ->
    result = 
      id: $e.attr("id") || "#{map.autoIDPrefix}#{map.count++}"
      lat: +getData($e, "latitude")
      lng: +getData($e, "longitude")
      title: getData($e, 'marker-title')

  # Called with a single html dom element as an argument, will
  # automatically set it up as a google map.
  map.setupElement = (e) ->
    $e = $ e
    location = map.locationDataForMap($e)
    point = new google.maps.LatLng location.lat, location.lng
    # Start setting up the map / create a map element.
    mapOptions = mapOptionsForElement $e
    mapOptions.center = point
    # Remove static map.
    $e.empty().addClass('dynamic-google-map').removeClass('static-google-map')
    # Make dynamic map.
    currentMap = new google.maps.Map e, mapOptions
    map.maps.push currentMap
    # Now, we need to finally add the marker to the map.
    markerOptions =
      position: point
      map:      currentMap
      title:    location.title
    #mergeDataOptions $e, markerOptions, markerOptionKeys, "marker-"
    marker = new google.maps.Marker markerOptions

    currentMap
  
  # On load, we'll install the maps.
  $(document).ready -> map.install()
  
  # Return map to set it up.
  map
  
)(jQuery)
