module API
  module V1
    class Movies < Grape::API
      DAYS = {"lunes" => 1, "martes" => 2, "miercoles" => 3, "jueves" => 4, "viernes" => 5, "sabado" => 6, "domingo" => 7}
      version 'v1', using: :path, vendor: 'reservation_api'

      resources :movies do

        desc 'Returns a movies by day'
        params do
          requires :day, type: String
        end
        get do
          data = params.slice("day").merge!("class_name" => Movie)
          status 200
          Services::ListCreator.new(data).list_movies

        end

        desc 'Create a movie'
        params do
          requires :name, type: String
          requires :description, type: String
          requires :image_url, type: String
        end
        post do

          data = params.slice("name", "description", "image_url").merge!("class_name" => Movie)
          movie = Services::Creator.new(data).create
          status movie.delete(:status_code)
          movie
          
        end
      end
    end
  end
end
