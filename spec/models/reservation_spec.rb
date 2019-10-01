require 'spec_helper'
require 'Time'
require_relative '../../app/models/movie.rb'
require_relative '../../app/models/showtime.rb'
require_relative '../../app/models/reservation.rb'

RSpec.describe Reservation, type: :model do
  before do
    Timecop.freeze(Time.new(2019,10,03))
  end

  after do
    Timecop.return
  end

  let(:movie) { Movie.create(name: "Finding Dory", description: "A little fish is lost", image_url: "https://d2e111jq13me73.cloudfront.net/sites") }
  let(:showtime) { Showtime.create(date: "2019-10-20", movie_id: movie.id ) }

  context 'validations' do
    context 'identity_number' do
      it 'when is nil' do
        reservation = Reservation.new(identity_number: nil, number_of_people: 8, showtime_id: showtime.id)
        expect(reservation.valid?).to eq false
        expect(reservation.errors).to eq( {:identity_number=>["must be present"]} )
      end
    end

    context 'description' do
      it 'when is nil' do
        reservation = Reservation.new(identity_number: 1234567890, number_of_people: nil)
        expect(reservation.valid?).to eq false
        expect(reservation.errors).to eq( {:number_of_people=>["must be present"], :showtime_id => ["must be present", "not exists"]} )
      end
    end
  end

  context '.update_showtime_capacity' do
    context 'when there is not capacity available' do
      it 'should not create reservation and not update showtime' do
        reservation = Reservation.new(identity_number: 123456, number_of_people: 12, showtime_id: showtime.id)
        expect(reservation.valid?).to be_falsey
        expect(reservation.errors).to eq(:number_of_people => ["exceed avaliable capacity for showtime #{showtime.id}"])
        result = reservation.save rescue false
        expect(result).to be_falsey
        expect(reservation.id).to be_nil
        expect(reservation.showtime.available_capacity).to eq(10)
        expect(Reservation.count).to be_zero
      end
    end
    context 'when there is capacity available' do
      it 'should create reservation and update showtime' do
        reservation = Reservation.new(identity_number: 123456, number_of_people: 3, showtime_id: showtime.id)
        expect(reservation.valid?).to be_truthy
        expect(reservation.save).to be_truthy
        expect(reservation.id).not_to be_nil
        expect(reservation.showtime.available_capacity).to eq(7)
        expect(Reservation.count).to eq(1)
      end
    end
  end

end
