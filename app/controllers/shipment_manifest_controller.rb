class ShipmentManifestController < ApplicationController
  def show
    @manifest = ShipmentManifest.new(params)
  end

  def edit
    @lot = Lot.find_by(id: params[:id])
    params[:id] = @lot.shipment_id
    @manifest = ShipmentManifest.new(params)
  end
end
