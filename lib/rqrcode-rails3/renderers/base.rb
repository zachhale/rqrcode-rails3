module RQRCode
  module Renderers
    class Base
      attr_reader :qrcode
      attr_reader :offset
      attr_reader :color
      attr_reader :cell_size
      attr_reader :fill

      # Initialize the renderer
      #   Options:
      #   offset - Padding around the QR Code (e.g. 10)
      #   fill   - Background color (e.g "ffffff" or :white)
      #   color  - Foreground color for the code (e.g. "000000" or :black)
      def initialize(qrcode, options = {})
        @qrcode    = qrcode
        @offset    = options[:offset].to_i || 0
        @color     = options[:color]       || "000"
        @cell_size = options[:cell_size]   || 11
        @fill      = options[:fill]
      end

      def render
        raise 'Must extend RQRCode::Renders::Base'
      end
    end
  end
end
