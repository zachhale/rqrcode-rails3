module RQRCode
  module Renderers
    class PNG < SVG
      def render
        svg = super
        image = MiniMagick::Image.read(svg) { |i| i.format "svg" }
        image.format "png"
        png = image.to_blob
      end
    end
  end
end
