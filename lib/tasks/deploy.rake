desc 'Deploy live application'
task :deploy do
  system('docker-compose --project-name sdaqs up --detach --build --force-recreate')
end
