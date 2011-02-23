module BHM
  module GoogleMaps
    class Builder
      BasicMarker = Struct.new(:to_s, :lat, :lng)
      
      def initialize(template, address, options)
        @template = template
        @address  = address
        @options  = options.symbolize_keys
      end
    
      def build_static_map(marker_options)
        lat, lng       = self.ll_pair
        address        = self.address_as_string
        address_proxy  = BasicMarker.new(address, lng, lat)
        static_map_url = StaticMap.for_address(address_proxy, marker_options.merge(@options[:static_map] || {}))
        @template.image_tag(static_map_url, {:alt => address}.reverse_merge(@options[:static_map_html] || {}))
      end
    
      def build_container
        marker_options = @options.delete(:marker) || {}
        lat, lng = self.ll_pair
        address = self.address_as_string
        container_options = {
          :'data-latitude' => lat,
          :'data-longitude' => lng
        }
        marker_options[:title] ||= address
        marker_options.each_pair do |k, v|
          container_options[:"data-marker-#{k.to_s.dasherize}"] = v
        end
        
        css_class = "#{BHM::GoogleMaps.container_class} #{BHM::GoogleMaps.static_map_class} #{@options.delete(:class)}"
        container_options[:class] = css_class

        # Pass along users options
        container_options.reverse_merge!(@options)
        image = build_static_map(marker_options)
        @template.content_tag(:div, image, container_options)
      end
    
      def to_html
        @to_html ||= build_container
      end
    
      def ll_pair
        BHM::GoogleMaps.address_to_lat_lng_proc.call(@address)
      end
      
      def address_as_string
        BHM::GoogleMaps.address_to_s_proc.call(@address)
      end
    end
  end
end
