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

  has_many :farms

  validates :name, presence: true
  validates :db_col, presence: true
  validates :id_code, presence: true
end
