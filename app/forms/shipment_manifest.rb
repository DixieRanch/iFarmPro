class ShipmentManifest
  attr_reader :shipment
  attr_reader :lots
  attr_reader :lot
  attr_reader :new_location

  def initialize(params)
    @shipment = Shipment.find_by(id: params[:id])
    @lots = Lot.all.where(shipment_id: @shipment.id)
    @lot = Lot.find_by(id: params[:lot_id])
    location_id = params[:lot][:freezer_location_id] if params[:lot]
    @new_location = FreezerLocation.find_by(id: location_id)
  end

  def save
    update_lot
    lot.save
  end

  private

  def update_lot
    lot.shipment_id = nil
    lot.freezer_location_id = new_location.id
  end
end
