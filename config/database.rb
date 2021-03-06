#require 'sinatra'
#require 'sinatra/sequel'
require 'dotenv'
require 'sequel'
Dotenv.load
#Sequel::Model.plugin :schema
# ...
#Sequel::Model.db = Sequel.sqlite('/tmp/test.db')
#Sequel.extension :blank

# Establish the database connection; or, omit this and use the DATABASE_URL
# environment variable as the connection string:
#DB = Sequel.sqlite('/tmp/test.db')
#DB = Sequel.connect(adapter: :postgres, database: ENV.fetch('DATABASE_NAME'), host: 'localhost')
#Sequel.connect(ENV.fetch('DATABASE_URL'))# || "postgres://localhost/#{ENV.fetch('DATABASE_NAME')}")
DB = Sequel.connect(ENV['DATABASE_URL'])
Sequel::Model.plugin :timestamps
#    DB = Sequel.connect(adapter: :postgres, database: 'cinema_development', host: 'localhost')
#set :database, 'sqlite://test.db'
#Dir['./models/*.rb'].each{|f| require f}

# At this point, you can access the Sequel Database object using the
# "database" object:
#puts "the foos table doesn't exist" if !database.table_exists?('moovies')
