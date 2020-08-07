class Shipping
  attr_reader :shipment
  attr_reader :location

  def initialize(params)
    @location = FreezerLocation.find_by(id: params[:location])
    @shipment = Shipment.find_by(id: params[:shipment])
  end

  def shipped_weight
    weight = 0
    shipment.lots.each do |lot|
      weight += lot.net_weight
    end
    weight
  end
end
