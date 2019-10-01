require 'sequel'
require 'pry'

class Reservation < Sequel::Model
  many_to_one :showtime

  def before_create
    super
    update_showtime_capacity(showtime_id, number_of_people)
  end

  def validate
    super
    errors.add(:identity_number, "must be present") if identity_number.nil?
    errors.add(:number_of_people, "must be present") if number_of_people.nil?
    errors.add(:showtime_id, "must be present") if showtime_id.nil?
    errors.add(:showtime_id, "not exists") if invalid_showtime?(showtime_id)
    errors.add(:number_of_people, "exceed avaliable capacity for showtime #{showtime_id}") if !invalid_showtime?(showtime_id) && invalid_capacity?(showtime_id, number_of_people)
  end

  def invalid_showtime?(showtime_id)
    Showtime.where(id: showtime_id).empty?
  end

  def invalid_capacity?(showtime_id, capacity)
    showtime = Showtime.find(showtime_id).last
    ( showtime.available_capacity - capacity ) < 0
  end

  def update_showtime_capacity(showtime_id, capacity)
    showtime = Showtime.where(id: showtime_id).last
    showtime.available_capacity -= capacity
    showtime.save
  end

end
