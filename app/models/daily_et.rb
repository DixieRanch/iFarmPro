# == Schema Information
#
# Table name: daily_ets
#
#  id                 :integer          not null, primary key
#  date               :date
#  eth                :float
#  weather_station_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class DailyEt < ActiveRecord::Base
  belongs_to :weather_station

  validates :date,               presence: true
  validates :eth,                presence: true,
                                 numericality: { greater_than: 0.01,
                                                 less_than:    0.5 }
  validates :weather_station_id, presence: true
end
