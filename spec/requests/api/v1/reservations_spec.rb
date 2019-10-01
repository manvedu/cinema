require 'spec_helper'

RSpec.describe API::V1::Reservations, type: :api do
  include Rack::Test::Methods

  def app
    MOVIE_APP
  end

  before do
    Timecop.freeze(Time.new(2019,10,03))
    movie = Movie.create(name: "Finding Dory", description: "A little fish is lost", image_url: "https://d2e111jq13me73.cloudfront.net/sites")
    @showtime = Showtime.create(date: "2019-10-20", movie_id: movie.id )
    header 'Content-Type', 'application/json'
  end

  after do
    Timecop.return
  end


  let(:invalid_params) do
    {
      "showtime_id": @showtime.id,
    }
  end

  let(:complete_but_invalid_params) do
    {
      "showtime_id": @showtime.id,
      "identity_number": 1234567,
      "number_of_people":  " "
    }
  end

  let(:valid_params) do
    {
      "showtime_id": @showtime.id,
      "identity_number": 1234567,
      "number_of_people": 3
    }
  end

  describe 'GET /api/v1/reservations?initial_date=&end_date=' do
    context 'with not valid parameters' do
      it 'returns HTTP status 400' do
        get "/api/v1/reservations"
        expect(last_response.status).to eq 400
      end
    end
    context 'with valid parameters' do
      it 'returns HTTP status 200' do
        get "/api/v1/reservations?initial_date=2019-10-20&end_date=2019-10-23"
        expect(last_response.status).to eq 200
      end
      context 'and there is reservations in range date' do
        it 'returns list of reservations' do
          get "/api/v1/reservations?initial_date=2019-10-20&end_date=2019-10-23"
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = { 'reservations' => [ ] }.deep_symbolize_keys

          expect(body_response).to eq(expected_response)
        end
      end
      context 'and there is not reservations in range date' do
        it 'returns list empty' do
          movie1 = Movie.create(name: "Finding Dory II", description: "A little fish is lost", image_url: "https://d2e111jq13mee3.cloudfront.net/sites")
          movie2 = Movie.create(name: "Finding Nemo", description: "A little fish is lost", image_url: "https://23563.cloudfront.net/sites")
          movie3 = Movie.create(name: "Sherk", description: "Monsters and princess", image_url: "https://5896.cloudfront.net/sites")

          showtime1 = Showtime.create(date: "2019-10-21", movie_id: movie1.id )
          showtime2 = Showtime.create(date: "2019-10-22", movie_id: movie1.id )
          showtime3 = Showtime.create(date: "2019-10-22", movie_id: movie2.id )
          showtime4 = Showtime.create(date: "2019-10-24", movie_id: movie2.id )
          showtime5 = Showtime.create(date: "2019-10-28", movie_id: movie3.id )
          showtime6 = Showtime.create(date: "2019-10-23", movie_id: movie3.id )

          reservation1 = Reservation.create(identity_number: 1234567890, number_of_people: 2, showtime_id: showtime1.id)
          reservation2 = Reservation.create(identity_number: 1234890755, number_of_people: 2, showtime_id: showtime1.id)
          reservation3 = Reservation.create(identity_number: 1234567890, number_of_people: 2, showtime_id: showtime2.id)
          reservation4 = Reservation.create(identity_number: 1234567890, number_of_people: 2, showtime_id: showtime3.id)
          reservation5 = Reservation.create(identity_number: 1234567890, number_of_people: 2, showtime_id: showtime4.id)
          reservation6 = Reservation.create(identity_number: 1234000000, number_of_people: 2, showtime_id: showtime4.id)
          reservation7 = Reservation.create(identity_number: 1234567890, number_of_people: 2, showtime_id: showtime5.id)
          reservation8 = Reservation.create(identity_number: 1234567890, number_of_people: 2, showtime_id: showtime6.id)
          reservation9 = Reservation.create(identity_number: 1234890755, number_of_people: 2, showtime_id: showtime6.id)

          get "/api/v1/reservations?initial_date=2019-10-20&end_date=2019-10-23"
          body_response = JSON.parse(last_response.body).deep_symbolize_keys

          reservations = [ reservation1, reservation2, reservation3, reservation4, reservation8, reservation9 ]
          expected_response = {
            'reservations' => reservations.map{|m| m.values}
          }.deep_symbolize_keys

          expect(body_response).to eq(expected_response)
        end
      end
    end
  end

  describe 'POST /api/v1/reservations' do

    context 'with valid parameters' do

      it 'returns HTTP status 201 - Created' do
        post "/api/v1/reservations", valid_params.to_json
        expect(last_response.status).to eq 201
      end

      it 'creates a reservation' do
        expect(Reservation.count).to be_zero
        post "/api/v1/reservations", valid_params.to_json
        expect(Reservation.count).to eq(1)
      end

      it 'creates a reservation with the specified attributes' do
        expect(Reservation.count).to be_zero
        post "/api/v1/reservations", valid_params.to_json
        reservation = Reservation.last
        expect(reservation).not_to be_nil
        valid_params.each do |k,_|
          expect( reservation.send(k) ).to eq( valid_params[k] )
        end
      end

      it 'returns the appropriate JSON response' do
        expect(Reservation.count).to be_zero
        post "/api/v1/reservations", valid_params.to_json
        body_response = JSON.parse(last_response.body).deep_symbolize_keys
        expected_response = {
          'attributes' =>  Reservation.last.values
        }.deep_symbolize_keys

        expect(body_response).to eq(expected_response)
      end

      it 'but showtime has not capacity, not create a reservation with the specified attributes' do
        expect(Reservation.count).to be_zero
        @showtime.update(available_capacity: 0)
        @showtime.reload

        post "/api/v1/reservations", valid_params.to_json

        body_response = JSON.parse(last_response.body).deep_symbolize_keys
        expected_response = {
          :error => "number_of_people exceed avaliable capacity for showtime #{@showtime.id}"
        }
     
        expect(body_response).to eq(expected_response)
        reservation = Reservation.last
        expect(reservation).to be_nil
        expect(Reservation.count).to be_zero
      end

    end

    context 'with invalid attributes' do
      context 'and some attribute is missing' do
        it 'returns HTTP status 400 - Bad Request' do
          post "/api/v1/reservations", invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'does not create a reservation' do
          expect(Reservation.count).to be_zero
          post "/api/v1/reservations", invalid_params.to_json
          expect(Reservation.count).to be_zero
        end
       
        it 'returns the appropriate JSON response' do
          expect(Reservation.count).to be_zero
          post "/api/v1/reservations", invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "identity_number is missing, number_of_people is missing"
          }
       
          expect(body_response).to eq(expected_response)
        end

      end

      context 'and some attribute is wrong' do

        it 'and showtime_id not exists returns HTTP status 400 - Bad Request' do
          complete_but_invalid_params[:showtime] = @showtime.id + 3
          post "/api/v1/reservations", complete_but_invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'returns HTTP status 400 - Bad Request' do
          post "/api/v1/reservations", complete_but_invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'does not create a reservation' do
          expect(Reservation.count).to be_zero
          post "/api/v1/reservations", complete_but_invalid_params.to_json
          expect(Reservation.count).to be_zero
        end
       
        it 'and showtime_id not exists returns the appropriate JSON response with errors' do
          expect(Reservation.count).to be_zero
          complete_but_invalid_params[:showtime_id] = @showtime.id + 3
          post "/api/v1/reservations", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "number_of_people is invalid"
          }
       
          expect(body_response).to eq(expected_response)
        end

        it 'and capacity exceed 10 returns the appropriate JSON response with errors' do
          expect(Reservation.count).to be_zero
          complete_but_invalid_params[:number_of_people] = 12
          post "/api/v1/reservations", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "number_of_people exceed avaliable capacity for showtime #{@showtime.id}"
          }
       
          expect(body_response).to eq(expected_response)
        end

        it 'returns the appropriate JSON response with errors' do
          expect(Reservation.count).to be_zero
          post "/api/v1/reservations", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "number_of_people is invalid"
          }
       
          expect(body_response).to eq(expected_response)
        end

      end

    end

  end

end
