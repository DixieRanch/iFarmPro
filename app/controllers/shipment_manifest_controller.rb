class ShipmentManifestController < ApplicationController
  def show
    @shipment = Shipment.find_by(id: params[:id])
    @lots = Lot.all.where(shipment_id: @shipment.id)
  end

  def edit
  end
end
