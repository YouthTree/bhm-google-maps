module BHM
  module GoogleMaps
    module Helper
      
      def include_gmap_js
        @included_map_js ||= begin
          BHM::GoogleMaps.include_js_proc.call(self)
          true
        end
      end
      
      # Draw a google map of 1 or more locations
      def gmap(addresses, options={})
        include_gmap_js unless options[:static]
        BHM::GoogleMaps::Builder.new(self, addresses, options).to_html
      end
      
      def google_maps_url(sensor = false)
        "http://maps.google.com/maps/api/js?sensor=#{sensor}"
      end
    end
  end
end
