require 'logger'

case ENV['RACK_ENV']
when 'development'
  require 'rack/unreloader'

  UNRELOADER = Rack::Unreloader.new(
    subclasses: %w[Roda],
    logger: Logger.new($stdout)
  ) { App }
  UNRELOADER.require('app/app.rb') { 'App' }
  run(UNRELOADER)
else
  require_relative 'app/app'
  run(App.freeze.app)
end
