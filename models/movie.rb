class Movie < Sequel::Model
  one_to_many :showtimes

  def validate
    super
    errors.add(:name, "must be present") if name.empty?
    errors.add(:description, "must be present") if description.empty?
    errors.add(:image_url, "must be present") if image_url.empty?
  end
end
