require 'spec_helper'
require 'Time'
require_relative '../../app/models/showtime.rb'
require_relative '../../app/models/movie.rb'

RSpec.describe Showtime, type: :model do
  before do
    @movie = Movie.create(name: "Peli 1", description: "peli 1", image_url: "peli 1")
    Timecop.freeze(Time.new(2019,10,03))
  end

  after do
    Timecop.return
  end

  context 'associations' do
    it 'correct relation for an existent movie' do
      showtime = Showtime.new(date: "2019-10-20", movie_id: @movie.id + 2)
      expect(showtime.valid?).to eq false
      expect(showtime.errors).to eq({:movie_id=>["not exists"]})
      expect(Showtime.count).to be_zero
    end
  end

  context 'validations' do
    it 'when date or movie_id field is nil' do
      showtime = Showtime.new(date: nil, movie_id: nil)
      expect(showtime.valid?).to be_falsey
      expect(showtime.errors).to eq({:date=>["must be present"], :movie_id=>["must be present"]})
    end
    it 'when date field is empty' do
      showtime = Showtime.new(date: " ", movie_id: @movie.id)
      expect(showtime.valid?).to be_falsey
      expect(showtime.errors).to eq({:date=>["must be present"]})
    end
    it 'available_capacity is 10 by default' do
      showtime = Showtime.new(date: "2019-10-20", movie_id: @movie.id)
      showtime.save
      expect(showtime.available_capacity).to eq(10)
    end
    it 'date is not older than today' do
      showtime = Showtime.new(date: "2019-09-20", movie_id: @movie.id)
      expect(showtime.valid?).to be_falsey
      expect(showtime.errors).to eq({:date=>["is before today"]})
    end
    it 'date is taken by movie' do
      Showtime.create(date: "2019-10-20", movie_id: @movie.id)
      showtime = Showtime.new(date: "2019-10-20", movie_id: @movie.id)
      expect(showtime.valid?).to be_falsey

      expect(showtime.errors).to eq({:date=>["is already taken"]})

      movie = Movie.create(name: "Peli 2", description: "peli 1", image_url: "peli 2")
      showtime.movie_id = movie.id
      expect(showtime.valid?).to be_truthy
    end
  end

  context 'set valid format to date field' do
    it 'it should be YYYY-mm-dd' do
      showtime = Showtime.new(date: Time.now, movie_id: @movie.id)
      showtime.save
      expect(showtime.date).to eq("2019-10-03")
      expect(showtime.day_of_the_week).to eq(4)
    end
  end
end
