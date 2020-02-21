class Load
  include ActiveModel::Model

  attr_accessor :location, :lots

  def initialize(location = nil)
    @location = location
  end

  def self.all
    loads = []
    FreezerLocation.all.each do |loc|
      loads << Load.new(loc)
    end
    loads
  end

  def weight
    location.location_weight
  end
end
