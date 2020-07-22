class ShippingController < ApplicationController
  def new
    @shipment = Shipment.find_by(id: params[:shipment])
    @location = FreezerLocation.find_by(id: params[:location])
  end
end
