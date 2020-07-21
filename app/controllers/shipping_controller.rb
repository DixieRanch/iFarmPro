class ShippingController < ApplicationController
  def new
    @shipment = Shipment.find_by(id: params[:shipment])
  end
end
