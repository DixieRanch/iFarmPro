class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def new
    @shipment = Shipment.new
  end

  def create
    redirect_to new_shipment_path
  end
end
