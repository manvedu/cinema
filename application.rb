require 'grape'
require 'sequel'
require_relative 'config/database.rb'

# Load files from the models and api folders
#Dir["#{File.dirname(__FILE__)}/app/models/**/*.rb"].each { |f| require f }
#Dir["#{File.dirname(__FILE__)}/db/**"].each { |f| require f }
#Dir["#{File.dirname(__FILE__)}/app/api/**/*.rb"].each { |f| require f }

Dir["#{File.dirname(__FILE__)}/app/models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/services/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/api/**/*.rb"].each { |f| require f }

module API
  class Root < Grape::API
    format :json
    prefix :api

    # Simple endpoint to get the current status of our API.
    get :status do
      { status: 'ok' }
    end

    mount V1::Movies
    mount V1::Showtimes
    mount V1::Reservations
#puts "routes "*100
#puts API::Root.routes
  end
end

# Mounting the Grape application
ReservationApi = Rack::Builder.new {

  map "/" do
    run API::Root
  end

}
