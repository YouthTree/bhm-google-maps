module BHM
  module GoogleMaps
    module Helper
      
      # Install accompanying javascript file to make map dynamic
      def dynamic_map!
        @using_gmaps_js ||= begin
          BHM::GoogleMaps.include_js_proc.call(self)
          true
        end
      end
      
      # Draw a dynamic map of 1 or more locations
      def dynamic_map(addresses, options={})
        dynamic_map!
        BHM::GoogleMaps::Builder.new(self, addresses, options).to_html
      end
      
      # Draw a static map of 1 or more locations
      def static_map(addresses, options={})
        options.reverse_merge!(:no_container => true)
        BHM::GoogleMaps::Builder.new(self, addresses, options).to_html
      end
      
      # Have we installed the accompanying javascript file
      # Don't think this method needs to be exposed...
      def dynamic_map?
        @using_gmaps_js
      end    

      # Not sure what this is used for...
      def google_maps_url(sensor = false)
        "http://maps.google.com/maps/api/js?sensor=#{sensor}"
      end
    end
  end
end
