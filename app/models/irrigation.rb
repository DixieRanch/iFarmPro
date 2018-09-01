# == Schema Information
#
# Table name: irrigations
#
#  id         :integer          not null, primary key
#  time       :datetime
#  field_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  farm_id    :integer
#

class Irrigation < ActiveRecord::Base
  attr_accessor :next_irrigation

  belongs_to :field
  has_many :meter_readings, dependent: :restrict_with_error
  accepts_nested_attributes_for :meter_readings

  default_scope { where(company_id: Company.current_id) }

  validates :time, presence: true

  def formatted_date
    time.strftime('%B %-d, %Y') if time
  end

  def formatted_time
    time.strftime('%B %-d, %Y %R') if time
  end

  def self.last_for(field)
    field.irrigations.order('time').last || NullIrrigation.new(field)
  end

  def self.next_irrigations
    current_irrigations.each do |irrigation|
      irrigation.next_irrigation = irrigation.next_irrigation_date
    end
  end

  def next_irrigation_date
    date = time.to_date
    aw = max_aw * mad # initialize available water -> assumes field capacity
    while aw > 0
      aw += effective_rain(date) - daily_et(date)
      aw = field_capacity_after_excess_rain(aw)
      date += 1
    end
    date
  end

  private

  private_class_method def self.current_irrigations
    Field.includes(:irrigations).map do |field|
      last_for(field)
    end
  end

  def current_et
    @current_et ||= CurrentEt.order('doy')
  end

  def daily_et(date)
    etref(date.yday) * kcref(date.yday)
  end

  def effective_rain(date)
    return 0 unless rain(date)
    rain(date).amount * rain_coefficient if rain(date)
  end

  def et
    @et ||= Et.order('doy')
  end

  def etref(doy)
    current_et[doy - 1].send(station.db_col) || et[doy - 1].send(station.db_col)
  end

  def field_capacity_after_excess_rain(aw)
    return aw unless aw > max_aw * mad
    max_aw * mad
  end

  def kc
    @kc ||= Kc.order('doy')
  end

  def kcref(doy)
    kc[doy - 1].pecan
  end

  def mad
    0.45 # management allowed depletion as % of available water
  end

  def max_aw
    field.soil_class.aw # max available water for soil type
  end

  def rain(date)
    Rain.find_by(date: date)
  end

  def rain_coefficient
    0.8 # % of rain added to available water
  end

  def station
    field.block.farm.weather_station
  end
end
