module BHM
  module GoogleMaps
    class StaticMap
      URL = "http://maps.google.com/maps/api/staticmap?"
      COLOURS      = %w(red white green brown blue orange gray purple yellow black)
      LABELS       = ('A'..'Z').to_a

      def initialize(addresses, options = {})
        @addresses = addresses
        @params = {
          :sensor  => false,
          :size    => options[:size],
          :maptype => options.fetch(:type, "roadmap")
        }
        zoom = options.fetch(:zoom, @addresses.length > 1 ? nil : 15)
        @params[:zoom] = zoom if zoom
        @cycle_colors = options[:cycle_colors]
        @cycle_labels = options[:cycle_labels]
      end

      def <<(address)
        @addresses << address
      end

      def to_url
        "#{URL}#{@params.to_param}&#{build_marker_params}" .html_safe
      end

      protected

      def build_marker_params
        return "markers=#{to_ll @addresses.first}" if @addresses.size == 1
        @addresses.each_with_index.map do |address, index|
          return "markers=#{to_ll @addresses.first}" if @addresses.size == 1
          color = COLOURS[index % COLOURS.size] if @cycle_color
          label = LABELS[index % LABELS.size]  if @cycle_label
          "markers=color:#{color}|label:#{label}|#{to_ll(address)}"
        end.join("&")
      end

      def to_ll(address)
        "#{address.lat},#{address.lng}"
      end

    end
  end
end
