require 'spec_helper'

RSpec.describe API::V1::Showtimes, type: :api do
  include Rack::Test::Methods

  def app
    MOVIE_APP
  end

  before do
    @movie = Movie.create(name: "Finding Dory", description: "A little fish is lost", image_url: "https://d2e111jq13me73.cloudfront.net/sites")
    Timecop.freeze(Time.new(2019,10,03))
    header 'Content-Type', 'application/json'
  end

  after do
    Timecop.return
  end


  let(:invalid_params) do
    {
      "movie_id": @movie.id
    }
  end

  let(:complete_but_invalid_params) do
    {
      "movie_id": @movie.id,
      "date":" "
    }
  end

  let(:valid_params) do
    {
      "movie_id": Movie.last.id,
      "date":"2019-10-20"
    }
  end

  describe 'POST /api/v1/showtimes' do

    context 'with valid parameters' do

      it 'returns HTTP status 201 - Created' do
        post "/api/v1/showtimes", valid_params.to_json
        expect(last_response.status).to eq 201
      end

      it 'creates a showtime' do
        expect(Showtime.count).to be_zero
        post "/api/v1/showtimes", valid_params.to_json
        expect(Showtime.count).to eq(1)
      end

      it 'creates a showtime with the specified attributes' do
        expect(Showtime.count).to be_zero
        post "/api/v1/showtimes", valid_params.to_json
        showtime = Showtime.last
        expect(showtime).not_to be_nil
        valid_params.each do |k,_|
          expect( showtime.send(k) ).to eq( valid_params[k] )
        end
      end

      it 'returns the appropriate JSON response' do
        expect(Showtime.count).to be_zero
        post "/api/v1/showtimes", valid_params.to_json
        body_response = JSON.parse(last_response.body).deep_symbolize_keys
        expected_response = {
          'attributes' =>  Showtime.last.values
        }.deep_symbolize_keys

        expect(body_response).to eq(expected_response)
      end

    end

    context 'with invalid attributes' do
      context 'and some attribute is missing' do
        it 'returns HTTP status 400 - Bad Request' do
          post "/api/v1/showtimes", invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'does not create a showtime' do
          expect(Showtime.count).to be_zero
          post "/api/v1/showtimes", invalid_params.to_json
          expect(Showtime.count).to be_zero
        end
       
        it 'returns the appropriate JSON response' do
          expect(Showtime.count).to be_zero
          post "/api/v1/showtimes", invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "date is missing"
          }
       
          expect(body_response).to eq(expected_response)
        end

      end

      context 'and some attribute is wrong' do

        it 'and movie_id not exists returns HTTP status 400 - Bad Request' do
          complete_but_invalid_params[:movie_id] = @movie.id + 3
          post "/api/v1/showtimes", complete_but_invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'returns HTTP status 400 - Bad Request' do
          post "/api/v1/showtimes", complete_but_invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'does not create a showtime' do
          expect(Showtime.count).to be_zero
          post "/api/v1/showtimes", complete_but_invalid_params.to_json
          expect(Showtime.count).to be_zero
        end
       
        it 'and movie_id not exists returns the appropriate JSON response with errors' do
          expect(Showtime.count).to be_zero
          complete_but_invalid_params[:movie_id] = @movie.id + 3
          post "/api/v1/showtimes", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "date must be present, movie_id not exists"
          }
       
          expect(body_response).to eq(expected_response)
        end

        it 'and date is before today returns the appropriate JSON response with errors' do
          expect(Showtime.count).to be_zero
          complete_but_invalid_params[:date] = Time.now - 2
          post "/api/v1/showtimes", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "date is before today"
          }
       
          expect(body_response).to eq(expected_response)
        end

        it 'returns the appropriate JSON response with errors' do
          expect(Showtime.count).to be_zero
          post "/api/v1/showtimes", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "date must be present"
          }
       
          expect(body_response).to eq(expected_response)
        end

      end

    end

  end

end
