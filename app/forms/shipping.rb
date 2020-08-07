class Shipping
  def initialize(params)
    @location = FreezerLocation.find_by(id: params[:location])
    @shipment = Shipment.find_by(id: params[:shipment])
  end

  attr_reader :shipment
  attr_reader :location

  def shipped_weight
    weight = 0
    Lot.all.where(shipment_id: shipment.id).each do |lot|
      weight += lot.net_weight
    end
    weight
  end
end
