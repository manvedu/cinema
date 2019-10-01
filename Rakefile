desc 'Run console'
task :console do
  sh 'cd config'
  sh 'irb -r ./config/application'
end

##################
namespace :db do
  require "sequel"
  namespace :migrate do
    Sequel.extension :migration
    DB = Sequel.connect(ENV['DATABASE_URL'])

    desc "Perform migration reset (full erase and migration up)"
    task :reset do
      Sequel::Migrator.run(DB, "db/migrations", :target => 0)
      Sequel::Migrator.run(DB, "db/migrations")
      puts "<= sq:migrate:reset executed"
    end

    desc "Perform migration up/down to VERSION"
    task :to do
      version = ENV['VERSION'].to_i
      raise "No VERSION was provided" if version.nil?
      Sequel::Migrator.run(DB, "db/migrations", :target => version)
      puts "<= sq:migrate:to version=[#{version}] executed"
    end

    desc "Perform migration up to latest migration available"
    task :up do
      Sequel::Migrator.run(DB, "db/migrations")
      puts "<= sq:migrate:up executed"
    end

    desc "Perform migration down (erase all data)"
    task :down do
      Sequel::Migrator.run(DB, "db/migrations", :target => 0)
      puts "<= sq:migrate:down executed"
    end
  end
end

#########
#namespace :db do
#  require_relative 'config/application'
#  desc 'Create database'
#  task :create do
#    sh 'psql postgres -c "CREATE DATABASE cinema_development;"'
#  end
#
#  desc 'Create and migrate database'
#  task :migrate do
#    sh 'sequel -m db/migrations postgres://localhost/cinema_development'
#  end
#
#  desc 'Create and migrate database for testing'
#  task :testdb do
#    sh 'psql postgres -c "CREATE DATABASE cinema_test;"'
#    sh 'sequel -m db/migrations postgres://localhost/cinema_test'
#  end
#end
