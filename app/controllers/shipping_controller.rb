class ShippingController < ApplicationController
  def new
    @shipping = Shipping.new(params)
  end

  def update
    shipping = Shipping.new(params)

    shipping.update_lot

    if shipping.lot.save
      redirect_to new_shipping_path(
        shipment: shipping.lot.shipment_id, location: shipping.location
      )
    else
      redirect_to new_shipping_path
    end
  end
end
