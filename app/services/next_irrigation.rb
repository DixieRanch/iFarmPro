class NextIrrigation
  def initialize(irrigation, field)
    @irrigation = irrigation
    @field = field
    next_date
  end

  def next_date
    date = @irrigation.time.to_date
    aw = max_aw * mad # initialize available water -> assumes field capacity
    while aw > 0
      aw += effective_rain(date) - daily_et(date)
      aw = field_capacity_after_excess_rain(aw)
      date += 1
    end
    date
  end

  private

  def max_aw
    @field.soil_class.aw # max available water for soil type
  end

  def mad
    0.45 # management allowed depletion as % of available water
  end

  def effective_rain(date)
    return 0 unless rain(date)
    rain(date).amount * rain_coefficient if rain(date)
  end

  def rain(date)
    Rain.find_by(date: date)
  end

  def daily_et(date)
    etref(date.yday) * kcref(date.yday)
  end

  def etref(doy)
    current_et[doy - 1].send(station.db_col) || et[doy - 1].send(station.db_col)
  end

  def current_et
    @current_et ||= CurrentEt.order('doy')
  end

  def station
    @field.block.farm.weather_station
  end

  def kcref(doy)
    kc[doy - 1].pecan
  end

  def kc
    @kc ||= Kc.order('doy')
  end

  def field_capacity_after_excess_rain(aw)
    return aw unless aw > max_aw * mad
    max_aw * mad
  end

  def et
    @et ||= Et.order('doy')
  end
end
