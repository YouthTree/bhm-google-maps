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
        ll             = self.ll_pair
        address        = self.address_as_string
        address_proxy  = BasicMarker.new(address, ll[0], ll[1])
        static_map_url = StaticMap.for_address(, marker_options.merge(@options[:static_map] || {}))
        @template.image_tag(static_map_url, {:alt => address}.reverse_merge(@options[:static_map_html] || {}))
      end
    
      def build_container
        marker_options = @options[:marker] || {}
        ll = self.ll_pair
        address = self.address_proxy
        container_options = {}
        container_options['data-latitude'] = ll[0]
        container_options['data-longitude'] = ll[1]
        marker_options[:title] ||= address
        marker_options.each_pair do |k, v|
          container_options["data-marker-#{key.to_s.dasherize}"] = v
        end
        default_css_class = "#{BHM::GoogleMaps.container_class} #{BHM::GoogleMaps.static_map_class}"
        marker_options = merge_options_with_class(marker_options, :class => default_css_class)
        @template.content_tag(:div, build_static_map, marker_options)
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
    
      protected
    
      def merge_options_with_class(a, b)
        a, b = (a || {}).stringify_keys, (b || {}).stringify_keys
        css_class = [a['class'], b['class']].join(" ").squeeze(" ")
        a.merge(b).merge('class' => css_class)
      end
    end
  end
end