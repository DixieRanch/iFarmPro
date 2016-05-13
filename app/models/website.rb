class Website < ActiveRecord::Base
  has_many :weather_stations
end