module API
  module V1
    class Reservations < Grape::API
      version 'v1', using: :path, vendor: 'reservation_api'

      resources :reservations do

        desc 'Returns reservations in a range of dates'
        params do
          requires :end_date, type: String
          requires :initial_date, type: String
        end
        get do
          data = params.slice("initial_date", "end_date").merge!("class_name" => Reservation)
          status 200
          Services::ListCreator.new(data).list_reservations
        end

        desc 'Create a reservation'
        params do
          requires :showtime_id, type: Integer
          requires :identity_number, type: Integer
          requires :number_of_people, type: Integer
        end
        post do
          reservation = Reservation.new(
            showtime_id: params[:showtime_id],
            identity_number: params[:identity_number],
            number_of_people: params[:number_of_people]
          )

          data = params.slice("showtime_id", "identity_number", "number_of_people").merge!("class_name" => Reservation)
          reservation = Services::Creator.new(data).create
          status reservation.delete(:status_code)
          reservation

        end
      end
    end
  end
end
