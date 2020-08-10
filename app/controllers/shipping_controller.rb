class ShippingController < ApplicationController
  def new
    @shipping = Shipping.new(params)
  end

  def update
    shipping = Shipping.new(params)

    shipping.save
    redirect_to new_shipping_path(
      shipment: shipping.lot.shipment_id, location: shipping.location
    )
  end
end
