# == Schema Information
#
# Table name: weather_stations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  id_code    :string(255)
#  db_col     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class WeatherStation < ActiveRecord::Base

  belongs_to :website
  has_many :farms
  has_many :daily_ets

  validates :name,       presence: true
  validates :db_col,     presence: true
  validates :id_code,    presence: true
  validates :website_id, presence: true
  
  def update_et
    
  end
end