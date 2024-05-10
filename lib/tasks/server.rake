desc 'Launch development server'
task :server do
  system('bundle exec rackup -o 0.0.0.0')
end
task :s => :server
