# BHM Google Maps #

Helpers for Google Maps v3 in Rails - Using html 5, the google maps api v3 and the static maps api
Supports unobtrusive maps in Rails 3 (and 2.3, but preferably 3) using the new google maps v3 api.

## Installation ##

Installing bhm-google-maps is simple. To get started with a rails 3 app:

1. Add the gem to your Gemfile:

    gem "bhm-google-maps"
    
2. Generate the js into your app:

    rake bhm-google-maps:install
    
3. Configure as needed

Some parts of bhm-google-maps may need to be configured - e.g. out of the box, it will append the google
maps js url to the page and the gmap.js from where it was called, as an example of changing this, we suggest
creating `config/initializers/bhm_google_maps_config.rb` and configuring from there. e.g:

    # t is the scope of the view / helpers.
    # This will append it to a content_for section
    # instead of directly in the page.
    BHM::GoogleMaps.include_js_proc = proc do |t|
      t.content_for :extra_head, t.javascript_include_tag(t.google_maps_url(false), "gmap.js")
    end
    
For a fuller / more in depth reference, see configuration below.

## Usage ##

Currently, bhm-google-maps is designed to show a single map w/ static fallback. To do this,
you use the `draw_map_of` helper. You pass it an object you wish to plot, typically following the
convention that:

1. object.lat and object.lng return latitude / longitude respectively
2. object.to\_s returns the string representing the address / the address

Of course, this can be changed via other conventions. For this example, we'll use the following
class demo:

    class Location
      attr_accessor :address, :lat, :lng
      
      def initialize(address, lat, lng)
        @address = address
        @lat = lat
        @lng = lng
      end
      
      def to_s; address.to_s; end
      
    end
    
Then, in your view, you could simple call:

    <%= draw_map_of Location.new("My House", 12.345, 56.789) %>
  
Optionally, `draw\_map\_of` accepts a hash of options for:

* :static\_map\_html - options to pass to the image\_tag for the static map.
* :static\_map - options to pass to the BHM::GoogleMaps::StaticMap constructor. These include :type, :width and :height
* :marker - options to pass to the google.maps.Marker in js.

You also get the following helpers:

* `using\_gmaps\_js?` - whether or not the embed method has been called
* `use\_gmaps\_js` - calls your embed method for the js - see configuration.
* `google\_maps\_url(sensor = false)` - returns the url for the google maps api v3.
* `static\_map\_of\_addresses(addresses)` - returns an image tag for an array of addresses.
* `static\_map\_of\_address(address)` - returns an image tag for a given address

## Configuration ##

For configuration purposes, there are a set of options on `BHM::GoogleMaps`. You can
set them via `BHM::GoogleMaps.option_name = value`

* `container_class` - the map class for the container div, defaults to gmap. If changed, you must update the js.
* `static\_map\_class` - the class of the container div, removed via js when made dynamic.
* `include\_js_proc` - how to embed js in the page (e.g. using content\_for), defaults to using concat. Is called as a proc w/ the template passed as the only argument.
* `address\_to\_s\_proc` - passed an address, converts it to a string (defaults to to_s)
* `address\_to\_lat\_lng\_proc` - passed an address, returns an array w/ lat and lng.

Ideally these options should be set in an initializer.

## Note on Patches/Pull Requests ##
 
1. Fork the project.
2. Make your feature addition or bug fix.
3. Add tests for it. This is important so I don't break it in a future version unintentionally.
4. Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
5. Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright (c) 2010 Youth Tree. See LICENSE for details.
