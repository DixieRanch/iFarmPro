class WeatherStation < ActiveRecord::Base

  has_many :farms

  validates :name, presence: true
  validates :db_col, presence: true
  validates :id_code, presence: true
end