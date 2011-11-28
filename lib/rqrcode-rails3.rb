require 'action_controller'
require 'rqrcode'
require 'rqrcode-rails3/size_calculator'
require 'rqrcode-rails3/renderer'
require 'rqrcode-rails3/renderers/svg'
require 'rqrcode-rails3/renderers/png'

module RQRCode
  extend SizeCalculator

  RQRCode::Renderer.register :svg, "image/svg+xml"
  RQRCode::Renderer.register :png, "image/png"

  ActionController::Renderers.add :qrcode do |data, options|
    format = self.request.format.symbol
    response_data = RQRCode::Renderer.render(format, data, options)
    self.response_body = render_to_string(:text => response_data,
                                          :template => nil)
  end
end