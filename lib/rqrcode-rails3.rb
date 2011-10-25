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
    options[:svg] ||= {}
    
    if data.is_a? RQRCode::QRCode
      qrcode = data
    else
      options = {:size => RQRCode.minimum_qr_size_from_string(data)}.merge options
    
      qrcode = RQRCode::QRCode.new(data, options)
    end
    
    svg    = RQRCode::Renderers::SVG::render(qrcode, options[:svg])
    
    data = \
    if format == :png
      image = MiniMagick::Image.read(svg) { |i| i.format "svg" }
      image.format "png"
      png = image.to_blob
    else
      svg
    end
    
    self.response_body = render_to_string(:text => data, :template => nil)
  end
end