class Shipping
  def initialize(params)
    @location = FreezerLocation.find_by(id: params[:location])
  end

  def shipment
    Shipment.first
  end

  attr_reader :location

  def shipped_weight
    weight = 0
    Lot.all.where(shipment_id: shipment.id).each do |lot|
      weight += lot.net_weight
    end
    weight
  end
end
