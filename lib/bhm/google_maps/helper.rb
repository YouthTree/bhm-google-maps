module BHM
  module GoogleMaps
    module Helper
      
      def using_gmaps_js?
        @using_gmaps_js
      end

      def use_gmaps_js
        return if using_gmaps_js?
        BHM::GoogleMaps.include_js_proc.call(self)
        @using_gmaps_js = true
      end
      
      def google_maps_url(sensor = false)
        "http://maps.google.com/maps/api/js?sensor=#{sensor}"
      end
      
      def draw_map_of(address, options = {})
        use_gmaps_js
        BHM::GoogleMaps::Builder.new(self, address, options).to_html
      end
      
      # Given an array of addresses, will return an image an
      # image tag with a static google map plotting those points.
      def static_map_of_addresses(addresses, options = {})
        alt_text = "#{pluralize addresses.size, "address"} plotted on a map"
        html = BHM::GoogleMaps::StaticMap.for_addresses(addresses, options)        
        image_tag html, :alt => alt_text 
      end

      # Returns an image map with a single address plotted on a single static google map.
      def static_map_of_address(address, options = {})
        alt_text = BHM::GoogleMaps.address_to_s_proc.call(address)
        html = BHM::GoogleMaps::StaticMap.for_address(address, options)
        image_tag html, :alt => alt_text
      end
      
    end
  end
end
