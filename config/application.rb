require 'bundler'
require 'rack'
require 'active_support/all'
Bundler.require

require_relative '../config/environment'
require_relative '../config/database'
require_relative '../app/models/showtime'
require_relative '../app/models/movie'
require_relative '../app/models/reservation'

