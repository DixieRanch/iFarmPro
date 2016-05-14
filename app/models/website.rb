class Website < ActiveRecord::Base
  has_many :weather_stations
  
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :url,  presence: true, uniqueness: {case_sensitive: false, 
                                                scope: :url_suffix}
end