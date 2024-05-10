require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV.fetch('RACK_ENV') { 'production' })

require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/html_outputter'
require 'base64'
require 'logger'

# This web application downloads remote resources to a fileserver.
# Currently, its only use case is to retrieve ebooks from z-library.se.
class App < Roda
  LOGGER = Logger.new($stdout)

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

    r.get 'apple-touch-icon.png' do
      response.headers['content-type'] = 'image/png'
      Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAGAAAABgBAMAAAAQtmoLAAABhmlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TtSJVBzuoOGSoThZERQQXrUIRKoRaoVUHk5f+QZOGJMXFUXAtOPizWHVwcdbVwVUQBH9AnB2cFF2kxPuSQotYLzzex3n3HN67DxCqRaZZbWOApttmIhYVU+lVMfAKHwbQgRn0yMwy5iQpjpb1dU/dVHcRntW678/qVjMWA3wi8SwzTJt4g3hq0zY47xOHWF5Wic+JR026IPEj1xWP3zjnXBZ4ZshMJuaJQ8RiromVJmZ5UyOeJA6rmk75QspjlfMWZ61YZvV78hcGM/rKMtdpDSGGRSxBgggFZRRQhI0I7TopFhJ0Hm3hH3T9ErkUchXAyLGAEjTIrh/8D37P1spOjHtJwSjQ/uI4H8NAYBeoVRzn+9hxaieA/xm40hv+UhWY/iS90tDCR0DvNnBx3dCUPeByB+h/MmRTdiU/LSGbBd7P6JvSQN8t0LXmza1+jtMHIEmzit8AB4fASI6y11u8u7N5bv/21Of3A3qscqru5KsnAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH6AEZBwAFU5fg4AAAADBQTFRFAAAAAGomDTRDHp5JZceKmbDAqr45xdtc0goM0unv2O6J8Py6/GFf/zg6/3t5////StR26AAAAAF0Uk5TAEDm2GYAAAABYktHRA8YugDZAAABA0lEQVRYR9WUURHDIBBEsYAFLNRCLdRCLGABC7VQC7UQC1iIhZRluYQMadPPu/cBgexjhjnAuUvuBbRXuQ1lAsK3ylWyoU6QMPlj2wqE0IiVEETwlZMVlQkIPisxvgoxTlMfHyR1goR3YSpQ9Ad0C7mBojH+LmDkfQjOdXGlApS5MVVipMAD6Y6oFFCy/QDKSGasCNzwsrBlTywJa4UC+3WFakfImcKyyJbly56QN6R4NgWUDO08Y2RHSKkXUDL0tgS5QNwsSA1Lgjxg0CjgOv18+ZQJLBhjEFKSBSwKgpTQjvAo9HEIOWMW/2wIVEb4R78AhdJICCdxlYJII1/CSgWjfADxtgNjwTcx1QAAAABJRU5ErkJggg==')
    end

    r.get 'favicon.ico' do
      response.headers['content-type'] = 'image/vnd.microsoft.icon'
      Base64.decode64('AAABAAEAGBgAAAEACACHAgAAFgAAAIlQTkcNChoKAAAADUlIRFIAAAAYAAAAGAgGAAAA4Hc9+AAAAk5JREFUSImllU9oE1EQxn/riheJWHrRaA4qAVOJf6AESg4KPVTIIQUL1oNiPQqBCD2EkJ4sRaWgWPBQaAh6MAXrTTCCFA8xELyYYAKWohi7nkrB4EVY1sNmX/bP221qv8vOm3nzfW9m3u4qodFx9ovppQkDoJypKNNLE0Y5U1GsmLIfAYu40l4Xvp1nfxX7ngP7Ia+01x3kAEN3DxmWMMDBAA7Dvnj78riwr9745dn849OmsMu2KmQtMgCqb14JR/d3huHhOADb2022OpvMfj8qJbcjVI8o7goMO7EMWx2T7N3kFSGY9BHoJjqGtEXxdMqx/vjitDg5wPmLkxw7ckkIVO8lSD6uE6pHAJRuomNYFbhbJNozkss6RF7f/CrsE5EznDt1C4Av3567Z+K4RZ4KrBYNNX861mdte5KpKeChJ8f0OyFt0Uguy078JADq00fommba4TCAiAnksrQePJFR+b8HarGEWizB/IIzYFurxRJqOCyEZZBWoLY3nGsbgX7ndt9XyJu+XoUDC3jw/kNfzDLC4UBiC3v6VOixKNSqpm3Npb3hqXhXgWaj4a9SyMP45UBSO+S36Po1j0+PRc1n7+StRgOCDhIkAOYwreHqsah5o+gPGSD+pwuFPLqm0fLhkbbI6quuaWby6poj3lpdM6vs3aL/qsCN5uGQ5xD6AHnSCpZzCyznzBfKfXq3yEp6hpX0DACLhTnPHmkFY2MXqNU+m4m9ZDdqrv1+GOiHsxuSqSkWC3PMzt9X3LGgn77hF5DAQ2whaMi+SXvBP32a2wODhR/SAAAAAElFTkSuQmCC')
    end

    r.get ':id' do
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

    r.get 'robots.txt' do
      <<~TXT
        User-agent: *
        Disallow: /
      TXT
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
