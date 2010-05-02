require 'active_support'

module BHM
  module GoogleMaps
    
    autoload :StaticMap, 'bhm/google_maps/static_map'
    autoload :Helper,    'bhm/google_maps/helper'
    autoload :Builder,   'bhm/google_maps/builder'
    
    class << self
      attr_accessor :container_class, :static_map_class, :include_js_proc,
                    :address_to_s_proc, :address_to_lat_lng_proc
    end
    
    self.container_class         ||= "gmap"
    self.static_map_class        ||= "static-google-map"
    self.include_js_proc         ||= lambda { |t| t.concat(t.javascript_include_tag(t.google_maps_url(false), "gmap.js")) }
    self.address_to_s_proc       ||= lambda { |a| a.to_s }
    self.address_to_lat_lng_proc ||= lambda { |a| [a.lat, a.lng] }
    
    def self.configure
      yield self if block_given?
    end
    
    def self.install_helper!
      ::ActionView::Base.send(:include, BHM::GoogleMaps::Helper)
    end
    
    def self.install_js!
      from = File.expand_path("../../javascripts/gmap.js", File.dirname(__FILE__))
      if File.exist?(from) && defined?(Rails.root)
        FileUtils.cp from, Rails.root.join("public", "javascripts", "gmap.js")
      end
    end
    
    def self.install_barista_framework!
      coffeescript_dir = File.expand_path("../../coffeescripts/", File.dirname(__FILE__))
      Barista::Framework.register 'bhm-google-maps', coffeescript_dir
    end
    
    self.install_helper!            if defined?(::ActionView)
    self.install_barista_framework! if defined?(Barista::Framework)
    
    if defined?(Rails::Railtie)
      class Railtie < Rails::Railtie
        rake_tasks do
          load File.expand_path('./google_maps/tasks/bhm_google_maps.rake', File.dirname(__FILE__))
        end
      end
    end
  end
end