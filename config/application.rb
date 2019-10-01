require 'bundler'
require 'rack'
require 'active_support/all'
Bundler.require

require_relative '../config/environment'
require_relative '../config/database'
require_relative '../app/models/showtime'
require_relative '../app/models/movie'
require_relative '../app/models/reservation'
#Dir["#{File.dirname(__FILE__)}/app/models/**/*.rb"].each { |f| require f }
#Dir["#{File.dirname(__FILE__)}/app/api/**/*.rb"].each { |f| require f }

#Dir.glob('../app/**/*.rb').each { |file| require_relative file }
#puts "NOOO "*100
#puts Dir.glob('app/**/*.rb')
#%w{helpers models routes}.each {|dir| Dir.glob("#{dir}/*.rb", &method(:require))}
#Dir.glob('../app/models/*.rb').each {|o| require_relative o}

