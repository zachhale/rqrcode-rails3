module RQRCode
  class Renderer
    class << self
      @@renderers = {}

      def renderers
        @@renderers
      end

      def register(renderer, name, mime_type)
        unless renderer.ancestors.include?(RQRCode::Renderers::Base)
          raise 'Renderer must be a type of RQRCode::Renderers::Base'
        end

        @@renderers[name] = { :mime_type => mime_type,
                              :renderer => renderer }
        Mime::Type.register mime_type, name
        @@renderers
      end

      def render(format, data, options)
        unless renderers[format]
          raise "RQRCode renderer #{format} not registered"
        end

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

        renderer = renderers[format][:renderer]
        renderer.render(qrcode, options)
      end
    end
  end
end