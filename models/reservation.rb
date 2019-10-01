class Reservation < Sequel::Model
  many_to_one :showtime

  def validate
    super
    errors.add(:identity_number, "must be present") if identity_number.strip.empty?
    errors.add(:number_of_people, "must be present") if number_of_people.strip.empty?
  end
end
