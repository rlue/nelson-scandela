desc 'Launch development console'
task :console do
  system('bundle exec irb -r ./app/app')
end
task :c => :console
