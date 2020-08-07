class Shipping
  attr_reader :shipment
  attr_reader :location
  attr_reader :lot

  def initialize(params)
    @location = FreezerLocation.find_by(id: params[:location])
    @shipment = Shipment.find_by(id: params[:shipment])
    @lot = Lot.find_by(id: params[:lot][:id]) if params[:lot]
  end

  def shipped_weight
    weight = 0
    shipment.lots.each do |lot|
      weight += lot.net_weight
    end
    weight
  end

  def save
    update_lot
    lot.save
  end

  private

  def update_lot
    lot.shipment_id = shipment.id
    lot.freezer_location_id = nil
  end
end
