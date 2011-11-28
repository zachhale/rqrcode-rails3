require 'test_helper'

class RQRCode::RendererTest < ActiveSupport::TestCase
  test 'registering a renderer' do
    RQRCode::Renderer.register TestRenderer, :test, 'application/test'
    renderers = RQRCode::Renderer.renderers
    registered = {
      :renderer => TestRenderer,
      :mime_type => 'application/test'
    }
    assert_equal renderers[:test], registered
    assert MIME::Type.new('application/test').registered?
  end

  test 'svg render returns an SVG file' do
    svg = RQRCode::Renderer.render(:svg, "http://helloworld.com", :size => 4)
    assert_equal File.read('test/support/data/qrcode.svg'), svg
  end

  test 'png render returns an PNG file' do
    png = RQRCode::Renderer.render(:png, "http://helloworld.com", :size => 4)
    assert_equal File.read('test/support/data/qrcode.png')[0,4], png[0,4]
  end
end

class TestRenderer < RQRCode::Renderers::Base
end