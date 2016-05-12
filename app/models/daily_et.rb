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
end
