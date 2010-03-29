module BHM
  module GoogleMaps
    module Helper
      
      def using_gmaps_js?
        instance_variable_defined?(:@using_gmaps_js) && !@using_gmaps_js
      end
      
      def google_maps_url(sensor = false)
        "http://maps.google.com/maps/api/js?sensor=#{sensor}"
      end
      
      def use_gmaps_js
        return if using_gmaps_js?
        BHM::GoogleMaps.include_js_proc.call(self)
        @using_gmaps_js = true
      end
      
      def draw_map_of(address, options = {})
        use_gmaps_js
        BHM::GoogleMaps::Builder.new(self, address, options).to_html
      end
      
    end
  end
end