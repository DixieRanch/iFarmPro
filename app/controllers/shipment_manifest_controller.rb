class ShipmentManifestController < ApplicationController
  def show
    @shipment = Shipment.find_by(id: params[:id])
  end
end
