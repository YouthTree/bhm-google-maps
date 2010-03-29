require 'active_support'

module BHM
  module GoogleMaps
    
    autoload :StaticMap, 'bhm/google_maps/static_map'
    autoload :Helper,    'bhm/google_maps/helper'
    autoload :Builder,   'bhm/google_maps/builder'
    
    mattr_accessor :container_class
    self.container_class         ||= "gmap"
    
    mattr_accessor :static_map_class
    self.static_map_class        ||= "static-google-map"
    
    mattr_accessor :include_js_proc
    self.include_js_proc         ||= lambda { |t| t.concat(t.javascript_include_tag(t.google_maps_url(false), "gmap.js")) }
    
    mattr_accessor :address_to_s_proc
    self.address_to_s_proc       ||= lambda { |a| a.to_s }
    
    mattr_accessor :address_to_lat_lng_proc
    self.address_to_lat_lng_proc ||= lambda { |a| [a.lat, a.lng] }
    
    def self.configure
      yield self if block_given?
    end
    
    def self.install_helper!
      ::ActionView::Base.send(:include, BHM::GoogleMaps::Helper)
    end
    
    self.install_helper!
    
  end
end