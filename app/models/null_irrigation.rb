class NullIrrigation
  attr_reader :field
  attr_accessor :next_irrigation

  def initialize(field = nil)
    @field = field
  end

  def next_irrigation_date
    Time.zone.local(Time.zone.now.year) - 184.days
  end

  def time
    next_irrigation_date
  end
end
