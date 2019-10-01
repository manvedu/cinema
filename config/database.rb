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
puts "db "*100
puts ENV.fetch('DATABASE_NAME')
DB = Sequel.connect(adapter: :postgres, database: ENV.fetch('DATABASE_NAME'), host: 'localhost')
#    DB = Sequel.connect(adapter: :postgres, database: 'cinema_development', host: 'localhost')
Sequel::Model.plugin :timestamps
#set :database, 'sqlite://test.db'
#Dir['./models/*.rb'].each{|f| require f}

# At this point, you can access the Sequel Database object using the
# "database" object:
#puts "the foos table doesn't exist" if !database.table_exists?('moovies')
