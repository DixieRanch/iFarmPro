class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def new
  end
end
