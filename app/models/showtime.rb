require 'sequel'
require 'pry'

class Showtime < Sequel::Model
  many_to_one :movie
  one_to_many :reservations
  
  #showtimes = DB[:showtimes] 

  def before_create
    super
    self.date = parsed_date(date)
    self.day_of_the_week = Date.parse(parsed_date(date)).strftime("%u").to_i
  end

  def validate
    super
    errors.add(:date, "must be present") if date_not_present?(date)
    errors.add(:movie_id, "must be present") if movie_id.nil?
    errors.add(:date, "is before today") if parsed_date(date) && !valid_date?(date)
    errors.add(:movie_id, "not exists") if !movie_id.nil? && invalid_movie_id?(movie_id)
    errors.add(:date, "is already taken") if parsed_date(date) && day_taken?(movie_id, date)
    #errors.add(:available_capacity, "No more capacity") if available_capacity < 1
  end

  def invalid_movie_id?(movie_id)
    Movie.where(id: movie_id).empty?
  end

  def day_taken?(movie_id, date)
    return false unless self.id.nil?
    !Showtime.where(movie_id: movie_id, date: parsed_date(date)).empty?
  end

  def valid_date?(date)
    parsed_date(date) >= Time.now.strftime("%Y-%m-%d") rescue false
  end

  def date_not_present?(date)
    date.nil? || date.strip.empty?
  end

  def parsed_date(date)
    Date.parse(date).strftime("%Y-%m-%d") rescue nil
  end
end
