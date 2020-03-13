class Load
  include ActiveModel::Model

  attr_accessor :location, :lots
  delegate :id, to: :location

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
    lots.map(&:net_weight).sum
  end

  def lot_count
    lots.all.count
  end

  def move_to(new_location)
    lots.each do |lot|
      lot.move_to(new_location)
    end
  end

  def persisted?
    true
  end

  def location_contents
    if lots.any?
      unique_content_list
    else
      ''
    end
  end

  private

  def unique_content_list
    contents = []
    lots.each do |lot|
      contents << lot.content_name
    end
    contents.uniq { |x| x }.join(', ')
  end
end
