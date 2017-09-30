# == Schema Information
#
# Table name: irrigations
#
#  id         :integer          not null, primary key
#  time       :datetime
#  field_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  farm_id    :integer
#

class IrrigationsController < ApplicationController
  def index
    @irrigation = Irrigation.new
    get_irrigations
  end

  def create
    field = Field.find(params[:irrigation][:field_id])
    @irrigation = field.irrigations.new(irrigation_params)
    if @irrigation.save
      redirect_to irrigations_path
    else
      get_irrigations
      render :index
    end
  end

  def edit
    @irrigation = Irrigation.find(params[:id])
    get_irrigations
    render :index
  end

  def update
    @irrigation = Irrigation.find(params[:id])
    @irrigation.field_id = field.id
    if @irrigation.update(irrigation_params)
      flash[:success] = "Irrigation successfully updated."
      redirect_to irrigations_path
    else
      get_irrigations
      render :index
    end
  end

  private

    def get_irrigations
      @irrigations = Irrigation.page(params[:page]).order("time DESC")
    end

    def irrigation_params
      params.require(:irrigation).permit(permitted_params)
    end

    def permitted_params
      [:time, meter_attributes]
    end

    def meter_attributes
      { meter_readings_attributes: [:irrigation_well_id, :start, :stop, :id] }
    end

    def field
      Field.find(params[:irrigation][:field_id])
    end
end
