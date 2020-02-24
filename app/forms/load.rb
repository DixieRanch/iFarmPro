class Load
  include ActiveModel::Model

  attr_accessor :location, :lots

  def initialize(location = FreezerLocation.new)
    @location = location
    @lots = location.lots.all
  end

  def self.all
    loads = []
    FreezerLocation.by_name_numerically.each do |loc|
      loads << Load.new(loc)
    end
    loads
  end

  def weight
    Lot.where(freezer_location_id: location.id).map(&:net_weight).sum
  end

  def lot_total
    Lot.where(freezer_location_id: location.id).count
  end
end
