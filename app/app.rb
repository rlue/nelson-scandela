require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV.fetch('RACK_ENV') { 'production' })

require 'barby'
require 'barby/barcode/codabar'
require 'barby/barcode/code_25'
require 'barby/barcode/code_25_interleaved'
require 'barby/barcode/code_25_iata'
require 'barby/barcode/code_39'
require 'barby/barcode/code_93'
require 'barby/barcode/code_128'
require 'barby/barcode/gs1_128'
require 'barby/barcode/ean_13'
require 'barby/barcode/bookland'
require 'barby/barcode/ean_8'
require 'barby/barcode/upc_supplemental'
require 'barby/barcode/qr_code'
require 'barby/barcode/data_matrix'
require 'barby/outputter/html_outputter'
require 'logger'

# This web application downloads remote resources to a fileserver.
# Currently, its only use case is to retrieve ebooks from z-library.se.
class App < Roda
  LOGGER = Logger.new($stdout)

  opts[:root] = File.dirname(__FILE__)
  plugin :common_logger, LOGGER
  plugin :head
  plugin :public
  plugin :symbol_status

  plugin :not_found do
    raise HttpException.new('Nothing to see here!', :not_found)
  end

  plugin :error_handler do |e|
    LOGGER.error e.message
    LOGGER.error e.backtrace.join("\n")

    response.status = e.class.method_defined?(:status) ? e.status : :internal_server_error

    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
      <title>#{response.status} #{Rack::Utils::HTTP_STATUS_CODES[response.status]}</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@exampledev/new.css@1.1.2/new.min.css">
        <link rel="apple-touch-icon" href="/apple-touch-icon.png">
        <link rel="icon" type="image/png" href="/favicon.ico">
      </head>
      <body>
      <h3>🤷 #{response.status}: #{e.message}</h3>
      <pre>
      #{e.backtrace.drop(1).join("\n")}
      </pre>
      </body>
      </html>
    HTML
  end

  route do |r|
    r.public

    r.root do
      <<~HTML
        <!DOCTYPE html>
        <html>
        <head>
          <title>Barcodes for Everyone!</title>
          <meta charset="utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@exampledev/new.css@1.1.2/new.min.css">
          <link rel="apple-touch-icon" href="/apple-touch-icon.png">
          <link rel="icon" type="image/png" href="/favicon.ico">
        </head>
        <body>
          <h1>Nelson Scandela</h1>
          <p>🔖 Generate a barcode, then bookmark it for later</p>
          <form action="/barcode" method="get">
            <div>
              <label for="msg">Message/Data:</label>
              <input name="msg" id="msg" placeholder="012345789">
            </div>
            <div>
              <label for="sym">Symbology:</label>
              <select name="sym" id="sym">
                <option value="ean13">EAN</option>
                <option value="upca">UPC</option>
                <option value="code39">Code 39</option>
                <option value="code128">Code 128</option>
                <option value="qrcode">QR Code</option>
                <option value="codabar">Codabar</option>
                <option value="datamatrix">DataMatrix (Semacode)</option>
                <!-- Uncommon, hidden for now
                <option value="bookland">Bookland</option>
                <option value="code25">Code 25</option>
                <option value="code25_interleaved">Code 25 Interleaved</option>
                <option value="code25_iata">Code 25 IATA</option>
                <option value="code39_extended">Code 39 Extended</option>
                <option value="code93">Code 93</option>
                <option value="code128a">Code 128A</option>
                <option value="code128b">Code 128B</option>
                <option value="code128c">Code 128C</option>
                <option value="ean8">EAN-8</option>
                <option value="gs1128">GS1 128</option>
                <option value="upcsupplemental">UPC/EAN Supplemental</option>
                -->
              </select>
            </div>
            <div class="lds-ring" id="submit" ><input type="submit" value="Submit" /><div></div><div></div><div></div><div></div></div></div>
          </form>
        </body>
        </html>
      HTML
    end

    r.is 'barcode' do
      symbology_klass(r.params['sym'])
        .new(r.params['msg'])
        .then do |barcode|
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
            <body>#{barcode.to_html}</body>
            </html>
          HTML
        end
    end

    r.get 'robots.txt' do
      <<~TXT
        User-agent: *
        Disallow: /
      TXT
    end
  end

  def symbology_klass(symbology)
    case symbology
    when 'code25'
      Barby::Code25
    when 'code25_interleaved'
      Barby::Code25Interleaved
    when 'code25_iata'
      Barby::Code25IATA
    when 'code39'
      Barby::Code39
    when 'code39_extended'
      Barby::Code39Extended
    when 'code93'
      Barby::Code93
    when 'code128'
      Barby::Code128
    when 'code128a'
      Barby::Code128A
    when 'code128b'
      Barby::Code128B
    when 'code128c'
      Barby::Code128C
    when 'gs1128'
      Barby::GS1128
    when 'codabar'
      Barby::Codabar
    when 'ean13'
      Barby::EAN13
    when 'bookland'
      Barby::Bookland
    when 'upca'
      Barby::UPCA
    when 'ean8'
      Barby::EAN8
    when 'upcsupplemental'
      Barby::UPCSupplemental
    when 'qrcode'
      Barby::QrCode
    when 'datamatrix'
      Barby::DataMatrix
    end
  end
end

class HttpException < RuntimeError
  attr_reader :status

  def initialize(message, status)
    @status = status
    super(message)
  end
end
