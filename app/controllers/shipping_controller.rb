class ShippingController < ApplicationController
  def new
    @shipment = Shipment.find_by(id: params[:shipment])
    @location = FreezerLocation.find_by(id: params[:location])
  end

  def edit
    @shipment = Shipment.find(params[:id])
    @lot = Lot.find_by(id: params[:lot])
    @location = @lot.freezer_location
    update
  end

  def update
    @shipment = Shipment.find(params[:id])
    @lot = Lot.find_by(id: params[:lot])
    @location = @lot.freezer_location

    @lot.shipment_id = @shipment.id
    @lot.freezer_location_id = nil
    if @lot.save
      redirect_to new_shipping_path(shipment: @shipment.id, location: @location)
    else
      render new_shipping_path
    end
  end
end
