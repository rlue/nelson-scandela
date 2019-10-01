require 'sinatra'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/html_outputter'

set :bind, '0.0.0.0'

get '/:id' do
  <<~HTML
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <title>Nelson Scandela</title>
        <style type="text/css" media="screen">
          body { margin: 2vh 10vw; }

          table.barby-barcode {
            border-spacing: 0;
            margin: 0 auto;
            height: 96vh;
          }

          td.barby-cell { width: 3px; }
          td.barby-cell.on { background-color: #000; }
        </style>
      </head>
      <body>#{Barby::Code128.new(params['id']).to_html}</body>
    </html>
  HTML
end
