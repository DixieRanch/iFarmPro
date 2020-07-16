class ShipmentSelectionsController < ApplicationController
  def new
    @shipment_selection = ShipmentSelection.new
  end
end
