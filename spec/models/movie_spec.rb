require 'spec_helper'
require 'Time'
require_relative '../../app/models/showtime.rb'
require_relative '../../app/models/movie.rb'

RSpec.describe Movie, type: :model do
####errors.add(:name, "must be present") if name.empty?
####errors.add(:description, "must be present") if description.empty?
####errors.add(:image_url, "must be present") if image_url.empty?

  context 'associations' do
  end

  context 'validations' do
    context 'name' do
      it 'when is nil' do
        movie = Movie.new(name: nil, description: "Some description", image_url: "some url")
        expect(movie.valid?).to eq false
        expect(movie.errors).to eq( {:name=>["must be present"]} )
      end
      it 'when is empty string' do
        movie = Movie.new(name: "     ", description: "Some description", image_url: "some url")
        expect(movie.valid?).to eq false
        expect(movie.errors).to eq( {:name=>["must be present"]} )
      end
    end

    context 'description' do
      it 'when is nil' do
        movie = Movie.new(name: "Peli 1", description: nil, image_url: "some url")
        expect(movie.valid?).to eq false
        expect(movie.errors).to eq( {:description=>["must be present"]} )
      end
      it 'when is empty string' do
        movie = Movie.new(name: "Peli 1", description: "  ", image_url: "some url")
        expect(movie.valid?).to eq false
        expect(movie.errors).to eq( {:description=>["must be present"]} )
      end
    end

    context 'image_url' do
      it 'when is nil' do
        movie = Movie.new(name: "Peli 1", description: "Some description", image_url: nil)
        expect(movie.valid?).to eq false
        expect(movie.errors).to eq( {:image_url=>["must be present"]} )
      end
      it 'when is empty string' do
        movie = Movie.new(name: "Peli 1", description: "Some description", image_url: "  ")
        expect(movie.valid?).to eq false
        expect(movie.errors).to eq( {:image_url=>["must be present"]} )
      end
    end
  end

end
