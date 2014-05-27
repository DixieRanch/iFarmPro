class IrrigationsController < ApplicationController

  def index
    @irrigations = Irrigation.order("time DESC")
    @irrigation = Irrigation.new
  end

  def create
    field = Field.find(params[:irrigation][:field_id])
    @irrigation = field.irrigations.build(params[:irrigation].except(:field_id))
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
    @update_time = @irrigation.time.to_s(:long)
    render :index
  end

  def update
    field = Field.find(params[:irrigation][:field_id])
    @irrigation = Irrigation.find(params[:id])
    @irrigation.field_id = field.id
    if @irrigation.update_attributes(params[:irrigation].except(:field_id))
      flash[:success] = "Irrigation successfully updated."
      redirect_to irrigations_path
    else
      @irrigations = Irrigation.order("time DESC")
      render :index
    end
  end
end