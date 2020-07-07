class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def new
    @shipment = Shipment.new
    @shipments = Shipment.all
  end

  def create
    @shipment = Shipment.new(shipment_params)
    @shipments = Shipment.all
    if @shipment.save
      flash[:success] = 'Shipment successfully created'
      redirect_to new_shipment_path
    else
      render :new
    end
  end

  def edit
    @shipment = Shipment.find(params[:id])
    @shipments = Shipment.all
    render :new
  end

  def update
    @shipment = Shipment.find(params[:id])
    if @shipment.update(shipment_params)
      flash[:success] = 'Shipment successfully updated'
      redirect_to new_shipment_path
    else
      @shipments = Shipment.all
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
