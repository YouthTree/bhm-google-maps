module BHM
  module GoogleMaps

    class Location
      def initialize(object)
        @lat, @lng = BHM::GoogleMaps.address_to_lat_lng_proc.call(object)
        @address = BHM::GoogleMaps.address_to_s_proc.call(@address) 
      end
      attr_reader :lat, :lng, :address
    end


    class Builder
      def initialize(template, addresses, options)
        @template = template
        @addresses  = Array.wrap(addresses).map {|l| Location.new(l) }
        @options  = options.symbolize_keys
        @marker_options = @options.delete(:marker) || {}
        @static = @options.delete(:static)
        @css_class = "#{BHM::GoogleMaps.container_class} #{BHM::GoogleMaps.static_map_class} #{@options.delete(:class)}"
      end

      def to_html
        image = build_static_map
        @static ? image :  build_container(image) 
      end

      def build_static_map
        url = StaticMap.new(@addresses, @marker_options.merge(@options||{})).to_url
        @template.image_tag(url, {:alt => alt_text}.reverse_merge(@options||{}))
      end
      
      def build_container(image)
        container_options = { :class => @css_class }
        if selector = @options.delete(:location_data_selector)
          # Lat/Lng data is embedded elsewhere in the page
          container_options[:'data-locations-selector'] = selector
        elsif @addresses.length == 1
          embed_location_data_for_location(container_options)
        end

        #Pass along users html options
        #container_options.reverse_merge!(@options)
        @template.content_tag(:div, image, container_options)
      end
    
      def embed_location_data_for_location(container_options)
        lat, lng = @addresses.first.lat, @addresses.first.lng
        container_options.merge! 'data-latitude' => lat, 'data-longitude' => lng
        #@marker_options[:title] ||= self.address_as_string
        @marker_options.each_pair do |k, v|
          container_options[:"data-marker-#{k.to_s.dasherize}"] = v
        end                                    
      end

      def alt_text
        if (count = @addresses.length) > 1
          @template.pluralize(count, "address") + " plotted on a map"
        else
          BHM::GoogleMaps.address_to_s_proc.call(@addresses.first)
        end
      end 

    end
  end
end
