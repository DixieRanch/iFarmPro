# == Schema Information
#
# Table name: historic_ets
#
#  id                 :integer          not null, primary key
#  doy                :integer
#  eth                :float
#  weather_station_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class HistoricEt < ActiveRecord::Base
  belongs_to :weather_station
end
