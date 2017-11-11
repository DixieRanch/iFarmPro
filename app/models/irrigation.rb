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

  def self.current_irrigations
    Field.includes(:irrigations).map do |field|
      if field.irrigations.last
        field.irrigations.order('time').last
      else
        field.irrigations.new(
          time: Time.zone.local(Time.zone.now.year) - 184.days
        )
      end
    end
  end

  def self.next_irrigations
    current_irrigations.each do |irrigation|
      irrigation.next_irrigation =
        irrigation.next_irrigation_date
    end
  end

  def next_irrigation_date
    date = time.to_date
    aw = max_aw * mad # initialize available water -> assumes field capacity
    while aw > 0
      aw -= etref(date.yday) * kcref(date.yday)
      aw += rain(date).amount * rain_coefficient if rain(date) # add rain water
      aw = max_aw * mad if aw > max_aw * mad # Limited to field capacity
      date += 1
    end
    date
  end

  private

  def max_aw
    field.soil_class.aw # max available water for soil type
  end

  def station
    field.block.farm.weather_station
  end

  def mad
    0.45 # management allowed depletion as % of available water
  end

  def rain_coefficient
    0.8 # % of rain added to available water
  end

  def etref(doy)
    current_et[doy - 1].send(station.db_col) || et[doy - 1].send(station.db_col)
  end

  def kcref(doy)
    kc[doy - 1].pecan
  end

  def rain(date)
    Rain.find_by(date: date)
  end

  def current_et
    @current_et ||= CurrentEt.order('doy')
  end

  def kc
    @kc ||= Kc.order('doy')
  end

  def et
    @et ||= Et.order('doy')
  end
end
