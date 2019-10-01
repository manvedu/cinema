require 'sequel'

class Movie < Sequel::Model
  one_to_many :showtimes

  def validate
    super
    errors.add(:name, "must be present") if name_not_present?(name)
    errors.add(:description, "must be present") if description_not_present?(description)
    errors.add(:image_url, "must be present") if image_url_not_present?(image_url)
  end

  ["name", "description", "image_url"].each do |method|
    define_method "#{method}_not_present?" do |field|
      field.nil? || field.strip.empty?
    end
  end
end
