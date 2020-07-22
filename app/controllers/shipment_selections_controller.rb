class ShipmentSelectionsController < ApplicationController
  def new
    @shipment_selection = ShipmentSelection.new
    @location = FreezerLocation.find_by(params[:location])
  end

  def create
    redirect_to new_shipping_path(shipment:
                                    params[:shipment_selection][:shipment_id],
                                  location:
                                    params[:shipment_selection][:location])
  end
end
