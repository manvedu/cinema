module API
  module V1
    class Showtimes < Grape::API
      version 'v1', using: :path, vendor: 'reservation_api'

      resources :showtimes do

        desc 'Create a showtime'
        params do
          requires :movie_id, type: String
          requires :date, type: String
        end
        post do
          data = params.slice("movie_id", "date").merge!("class_name" => Showtime)
          showtime = Services::Creator.new(data).create
          status showtime.delete(:status_code)
          showtime
          
        end
      end
    end
  end
end
