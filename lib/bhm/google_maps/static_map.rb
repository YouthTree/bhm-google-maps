module BHM
  module GoogleMaps
    class StaticMap
      URL_TEMPLATE = "http://maps.google.com/maps/api/staticmap?%s"
      COLOURS      = %w(red white green brown blue orange gray purple yellow black)
      LABELS       = ('A'..'Z').to_a

      def initialize(options = {})
        @addresses = []
        @width, @height = options.fetch(:width, 540), options.fetch(:height, 400)
        @params = Hash.new.tap do |p|
          p[:sensor]  = false
          p[:size]    = "#{@width}x#{@height}"
          p[:maptype] = options.fetch(:type, "roadmap")
        end
      end

      def <<(address)
        @addresses << address
      end

      def to_url
        params = @params.to_param
        params << "&"
        params << build_marker_params
        URL_TEMPLATE % params
      end

      def self.for_address(address, opts = {})
        map = self.new(opts.reverse_merge(:zoom => 15))
        map << address
        map.to_url
      end

      def self.for_addresses(*addresses)
        map = self.new(addresses.extract_options!)
        addresses.flatten.each { |a| map << a }
        map.to_url
      end

      protected

      def build_marker_params
        params = []
        @addresses.each_with_index do |address, index|
          return "markers=#{to_ll @addresses.first}" if @addresses.size == 1
          color = COLOURS[index % COLOURS.size]
          label = LABELS[index % LABELS.size]
          params << "markers=color:#{color}|label:#{label}|#{to_ll(address)}"
        end
        params.join("&")
      end

      def to_ll(address)
        "#{address.lat},#{address.lng}"
      end

    end
  end
end