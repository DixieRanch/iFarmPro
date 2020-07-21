class ShipmentSelectionsController < ApplicationController
  def new
    @shipment_selection = ShipmentSelection.new
  end

  def create
    redirect_to new_shipping_path(shipment:
                                  params[:shipment_selection][:shipment_id])
  end
end
