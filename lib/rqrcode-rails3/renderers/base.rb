module RQRCode
  module Renderers
    class Base
      def render(qrcode, options = {})
        raise 'Must extend RQRCode::Renders::Base'
      end
    end
  end
end