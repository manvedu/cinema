desc 'Run console'
task :console do
  sh 'cd config'
  sh 'irb -r ./config/application'
end

namespace :db do
  require_relative 'config/application'
  desc 'Create database'
  task :create do
    sh 'psql postgres -c "CREATE DATABASE cinema_development;"'
  end

  desc 'Create and migrate database'
  task :migrate do
    sh 'sequel -m db/migrations postgres://localhost/cinema_development'
  end

  desc 'Create and migrate database for testing'
  task :testdb do
    sh 'psql postgres -c "CREATE DATABASE cinema_test;"'
    sh 'sequel -m db/migrations postgres://localhost/cinema_test'
  end
end
