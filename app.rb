require 'sinatra'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/cairo_outputter'

get '/:id' do
  Barby::Code128.new(params['id']).to_svg
end
