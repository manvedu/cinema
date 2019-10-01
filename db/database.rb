require 'sinatra'
require 'sinatra/sequel'

# Establish the database connection; or, omit this and use the DATABASE_URL
# environment variable as the connection string:
set :database, 'sqlite://test.db'
#DB = Sequel.sqlite('./test.db')

# At this point, you can access the Sequel Database object using the
# "database" object:
#puts "the foos table doesn't exist" if !database.table_exists?('moovies')
