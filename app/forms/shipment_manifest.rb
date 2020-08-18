class ShipmentManifest
  attr_reader :shipment
  attr_reader :lots
  attr_reader :lot

  def initialize(params)
    @shipment = Shipment.find_by(id: params[:id])
    @lots = Lot.all.where(shipment_id: @shipment.id)
    @lot = Lot.find_by(id: params[:lot_id])
  end
end
