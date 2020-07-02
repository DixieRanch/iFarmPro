class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def new
    @shipment = Shipment.new
  end

  def create
    @shipment = Shipment.new(shipment_params)

    if @shipment.save
      redirect_to new_shipment_path
    else
      render :new
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(permitted_params)
  end

  def permitted_params
    [:name, :date, :destination]
  end
end
