require 'spec_helper'

RSpec.describe API::Root, type: :api do
  include Rack::Test::Methods

  def app
    MOVIE_APP
  end

  describe 'GET /status' do
    before do
      header 'Content-Type', 'application/json'
      get '/api/status'
    end

    it 'returns HTTP status 200' do
      expect(last_response.status).to eq 200
    end

    it 'returns Unsupported media type' do
      expect(JSON.parse(last_response.body)).to eq("status" => "ok")
    end
  end
end
