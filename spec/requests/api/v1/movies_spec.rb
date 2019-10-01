require 'spec_helper'

RSpec.describe API::V1::Movies, type: :api do
  include Rack::Test::Methods

  def app
    MOVIE_APP
  end

  before do
    header 'Content-Type', 'application/json'
  end

  let(:invalid_params) do
    {
      "name":"peli2",
      "description":" "
    }
  end

  let(:complete_but_invalid_params) do
    {
      "name":"peli2",
      "description":" ",
      "image_url":" "
    }
  end

  let(:valid_params) do
    {
      "name":"peli2",
      "description":"peli1",
      "image_url":"peli2"
    }
  end

  describe 'GET /api/v1/movies' do
    before do
      Timecop.freeze(Time.new(2019,10,03))
      header 'Content-Type', 'application/json'
    end
 
    after do
      Timecop.return
    end

    context 'with valid parameters' do
      it 'returns HTTP status 200' do
        get "/api/v1/movies?day=lunes"
        expect(last_response.status).to eq 200
      end
      
      context 'and there is movies in selected day' do
        it 'returns list of movies in that day' do
          movie1 = Movie.create(name: "Finding Dory", description: "A little fish is lost", image_url: "https://d2e111jq13me73.cloudfront.net/sites")
          movie2 = Movie.create(name: "Finding Nemo", description: "A little fish is lost", image_url: "https://23563.cloudfront.net/sites")
          movie3 = Movie.create(name: "Sherk", description: "Monsters and princess", image_url: "https://5896.cloudfront.net/sites")
          showtime1 = Showtime.create(date: "2019-10-21", movie_id: movie1.id )
          showtime2 = Showtime.create(date: "2019-10-22", movie_id: movie1.id )
          showtime3 = Showtime.create(date: "2019-10-22", movie_id: movie2.id )
          showtime4 = Showtime.create(date: "2019-10-28", movie_id: movie3.id )

          get "/api/v1/movies?day=lunes"
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            'movies' => [ movie1.values, movie3.values ]
          }.deep_symbolize_keys

          expect(body_response).to eq(expected_response)
        end
      end
      context 'and there is not movies in selected day' do
        it 'returns list empty' do
          get "/api/v1/movies?day=viernes"
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            'movies' => [
            ]
          }.deep_symbolize_keys

          expect(body_response).to eq(expected_response)
        end
      end
    end
    context 'with not valid parameters' do
      it 'returns HTTP status 400' do
        get "/api/v1/movies"
        expect(last_response.status).to eq 400
      end
    end
  end

  describe 'POST /api/v1/movies' do

    context 'with valid parameters' do

      it 'returns HTTP status 201 - Created' do
        post "/api/v1/movies", valid_params.to_json
        expect(last_response.status).to eq 201
      end

      it 'creates a movie' do
        expect(Movie.count).to be_zero
        post "/api/v1/movies", valid_params.to_json
        expect(Movie.count).to eq(1)
      end

      it 'creates a movie with the specified attributes' do
        expect(Movie.count).to be_zero
        post "/api/v1/movies", valid_params.to_json
        movie = Movie.last
        expect(movie).not_to be_nil
        valid_params.each do |k,_|
          expect( movie.send(k) ).to eq( valid_params[k] )
        end
      end

      it 'returns the appropriate JSON response' do
        expect(Movie.count).to be_zero
        post "/api/v1/movies", valid_params.to_json
        body_response = JSON.parse(last_response.body).deep_symbolize_keys
        expected_response = {
          'attributes' =>  Movie.last.values
        }.deep_symbolize_keys

        expect(body_response).to eq(expected_response)
      end

    end

    context 'with invalid attributes' do
      context 'and some attribute is missing' do
        it 'returns HTTP status 400 - Bad Request' do
          post "/api/v1/movies", invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'does not create a movie' do
          expect(Movie.count).to be_zero
          post "/api/v1/movies", invalid_params.to_json
          expect(Movie.count).to be_zero
        end
       
        it 'returns the appropriate JSON response' do
          post "/api/v1/movies", invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "image_url is missing"
          }
       
          expect(body_response).to eq(expected_response)
        end

      end

      context 'and some attribute is empty string' do

        it 'returns HTTP status 400 - Bad Request' do
          post "/api/v1/movies", complete_but_invalid_params.to_json
          expect(last_response.status).to eq 400
        end
       
        it 'does not create a movie' do
          expect(Movie.count).to be_zero
          post "/api/v1/movies", complete_but_invalid_params.to_json
          expect(Movie.count).to be_zero
        end
       
        it 'returns the appropriate JSON response' do
          expect(Movie.count).to be_zero
          post "/api/v1/movies", complete_but_invalid_params.to_json
          body_response = JSON.parse(last_response.body).deep_symbolize_keys
          expected_response = {
            :error => "description must be present, image_url must be present"
          }
       
          expect(body_response).to eq(expected_response)
        end

      end

    end

  end

end
