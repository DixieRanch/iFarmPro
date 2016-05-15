class AverageEt < ActiveRecord::Base
  belongs_to :weather_station
  
  validates :doy,                presence: true
  validates :weather_station_id, presence: true
  validates :eth,                presence: true, 
                                 numericality: { greater_than: 0.01,
                                                 less_than:    0.5 }
end
