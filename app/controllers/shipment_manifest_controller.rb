class ShipmentManifestController < ApplicationController
  def show
    @manifest = ShipmentManifest.new(params)
  end

  def edit
    @lot = Lot.find_by(id: params[:id])
  end
end
