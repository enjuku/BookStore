desc 'Recreate database'
    task :prepare do
    sh "rake db:drop db:create db:migrate db:seed"
end
