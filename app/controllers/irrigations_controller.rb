class IrrigationsController < ApplicationController

  def index
    @irrigations = Irrigation.order("time DESC")
    @irrigation = Irrigation.new
  end

  def create
    field = Field.find(params[:irrigation][:field_id])
    @irrigation = field.irrigations.new(irrigation_params)
    if @irrigation.save
      redirect_to irrigations_path
    else
      @irrigations = Irrigation.order("time DESC")
      render :index
    end
  end

  def edit
    @irrigations = Irrigation.order("time DESC")
    @irrigation = Irrigation.find(params[:id])
    # @update_time = @irrigation.time.to_s(:long)
    render :index
  end

  def update
    field = Field.find(params[:irrigation][:field_id])
    @irrigation = field.irrigations.find(params[:id])
    @irrigation.field_id = field.id
    if @irrigation.update(irrigation_params)
      flash[:success] = "Irrigation successfully updated."
      redirect_to irrigations_path
    else
      @irrigations = Irrigation.order("time DESC")
      render :index
    end
  end

private
    def irrigation_params
      params.require(:irrigation).permit(permitted_params)
    end

    def permitted_params
      [:time, meter_attributes]
    end

    def meter_attributes
      { meter_readings_attributes: [:irrigation_well_id, :start, :stop, :id] }
    end
end