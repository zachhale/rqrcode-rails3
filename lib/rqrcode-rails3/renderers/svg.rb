module RQRCode
  module Renderers
    class SVG < RQRCode::Renderers::Base
      def render
        # height and width dependent on offset and QR complexity
        dimension = (qrcode.module_count*cell_size) + (2*offset)

        xml_tag   = %{<?xml version="1.0" standalone="yes"?>}
        open_tag  = %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events" width="#{dimension}" height="#{dimension}">}
        close_tag = "</svg>"

        body = render_body

        svg = [xml_tag, open_tag, body, close_tag].join("\n")
      end

      def render_body
        body = []

        qrcode.modules.each_index do |y_module|
          tmp = []
          qrcode.modules.each_index do |x_module|
            cell = render_cell(y_module, x_module)
            tmp << cell if cell
          end
          body << tmp.join
        end

        if fill
          body.unshift %{<rect width="#{dimension}" height="#{dimension}" x="0" y="0" style="fill:##{fill}"/>}
        end

        body.join("\n")
      end

      def render_cell(y_module, x_module)
        y = y_module*cell_size + offset
        x = x_module*cell_size + offset

        if qrcode.is_dark(y_module, x_module)
          %{<rect width="#{cell_size}" height="#{cell_size}" x="#{x}" y="#{y}" style="fill:##{color}"/>}
        end
      end
    end
  end
end
