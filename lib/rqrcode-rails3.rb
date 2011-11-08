require 'action_controller'
require 'rqrcode'
require 'rqrcode-rails3/size_calculator.rb'
require 'rqrcode-rails3/renderers/svg.rb'

module RQRCode
  Mime::Type.register "image/svg+xml", :svg
  Mime::Type.register "image/png",     :png

  extend SizeCalculator

  ActionController::Renderers.add :qrcode do |data, options|
    format = self.request.format.symbol

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

    svg = RQRCode::Renderers::SVG::render(qrcode, options)

    response_data = \
    if format == :png
      image = MiniMagick::Image.read(svg) { |i| i.format "svg" }
      image.format "png"
      png = image.to_blob
    else
      svg
    end

    self.response_body = render_to_string(:text => response_data, :template => nil)
  end
end