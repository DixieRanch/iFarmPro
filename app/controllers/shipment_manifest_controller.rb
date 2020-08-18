class ShipmentManifestController < ApplicationController
  def show
    @manifest = ShipmentManifest.new(params)
  end

  def edit
    params[:lot_id] = params[:id]
    params[:id] = Lot.find_by(id: params[:id]).shipment_id
    @manifest = ShipmentManifest.new(params)
  end
end
