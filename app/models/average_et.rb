# == Schema Information
#
# Table name: average_ets
#
#  id                 :integer          not null, primary key
#  doy                :integer
#  eth                :float
#  weather_station_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class AverageEt < ActiveRecord::Base
  belongs_to :weather_station

  validates :doy,                presence: true,
                                 numericality: { only_integer: true,
                                                 greater_than:   0,
                                                 less_than:    367 }
  validates :weather_station_id, presence: true
  validates :eth,                presence: true,
                                 numericality: { greater_than: 0.01,
                                                 less_than:    0.5 }
end
