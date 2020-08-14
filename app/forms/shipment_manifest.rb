class ShipmentManifest
  attr_reader :shipment
  attr_reader :lots

  def initialize(params)
    @shipment = Shipment.find_by(id: params[:id])
    @lots = Lot.all.where(shipment_id: @shipment.id)
  end
end
