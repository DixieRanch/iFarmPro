class ShippingController < ApplicationController
  def new
    @shipping = Shipping.new(params)
    @shipment = @shipping.shipment
    @location = @shipping.location
  end

  def edit
    @shipment = Shipment.find(params[:id])
    @lot = Lot.find_by(id: params[:lot])
    @location = @lot.freezer_location
  end

  def update
    @lot = Lot.find_by(id: params[:lot][:id])
    @location = @lot.freezer_location

    update_lot(@lot, params)

    if @lot.save
      redirect_to new_shipping_path(
        shipment: @lot.shipment_id, location: @location
      )
    else
      redirect_to new_shipping_path
    end
  end

  private

  def update_lot(lot, params)
    lot.shipment_id = Shipment.find(params[:id]).id
    lot.freezer_location_id = nil
  end

  def shipped_weight(shipment)
    weight = 0
    Lot.all.where(shipment_id: shipment.id).each do |lot|
      weight += lot.net_weight
    end
    weight
  end
end
