module BHM
  module GoogleMaps
    class StaticMap
      URL_TEMPLATE = "http://maps.google.com/maps/api/staticmap?%s"
      COLOURS      = %w(red white green brown blue orange gray purple yellow black)
      LABELS       = ('A'..'Z').to_a

      def initialize(options = {})
        @addresses = Array.wrap(options[:addresses])
        @width  = options.fetch(:width, 540)
        @height = options.fetch(:height, 400)
        @params = {
          :sensor  => false,
          :size    => "#{@width}x#{@height}",
          :maptype => options.fetch(:type, "roadmap"),
          :zoom    => options.fetch(:zoom, 15)
        }
      end

      def <<(address)
        @addresses << address
      end

      def to_url
        params = @params.to_param
        params << "&"
        params << build_marker_params
        (URL_TEMPLATE % params).html_safe
      end

      def self.for_address(address, opts = {})
        options = opts.reverse_merge(:addresses => address)
        new(options).to_url
      end

      # For backwards compatibility, can pass in an array or a splat of addresses.
      # I think its probably okay to drop the splat case, since people probably aren't
      # writting code against this class, just the Helpers
      def self.for_addresses(*args)
        options = args.extract_options!
        addresses = (args.length == 1 and args[0].is_a? Array) ?  args[0] :  args
        options = options.reverse_merge(:zoom => nil, :addresses => addresses)
        new(options).to_url
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
