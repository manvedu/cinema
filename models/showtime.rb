class Showtime < Sequel::Model
  many_to_one :movie
  one_to_many :reservations
  
  def validate
    super
    errors.add(:date, "must be present") if date.empty?
    errors.add(:available_capacity, "No more capacity") if available_capacity < 1
  end
end
