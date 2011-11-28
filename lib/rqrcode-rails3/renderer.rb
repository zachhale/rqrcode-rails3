module RQRCode
  class Renderer
    class << self
      @@renderers = {}

      def renderers
        @@renderers
      end

      def register(name, mime_type)
        @@renderers[name] = mime_type
        Mime::Type.register mime_type, name
        @@renderers
      end

      def render(format, data, options)
        options ||= {}
        level = options.delete(:level)
        size = options.delete(:size)

        if data.is_a? RQRCode::QRCode
          qrcode = data
        else
          level ||= :h
          size ||= RQRCode.minimum_qr_size_from_string(data, level)
          qrcode = RQRCode::QRCode.new(data, :size => size, :level => level)
        end

        renderer = "RQRCode::Renderers::#{format.to_s.upcase}".constantize
        renderer.render(qrcode, options)
      end
    end
  end
end