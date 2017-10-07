# == Schema Information
#
# Table name: farms
#
#  id                 :integer          not null, primary key
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  company_id         :integer
#  weather_station_id :integer
#

class FarmsController < ApplicationController
  skip_before_action :farm_setup, only: [:new, :create, :edit, :update]

  def index
    @farms = Farm.all
  end

  def show
    @farm = Farm.find(params[:id])
  end

  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(farm_params)
    if @farm.save!
      flash[:success] = 'New farm successfully added.'
      redirect_to farms_path
    else
      render 'new'
    end
  end

  def edit
    @farm = Farm.find(params[:id])
  end

  def update
    @farm = Farm.find(params[:id])
    if @farm.update(farm_params)
      flash[:success] = 'Updated'
      redirect_to @farm
    else
      render 'edit'
    end
  end

  private

  def farm_params
    params.require(:farm).permit(permitted_params)
  end

  def permitted_params
    [:name, :weather_station_id, wells_attributes, blocks_attributes]
  end

  def wells_attributes
    { irrigation_wells_attributes: [:name, :pod_code, :id] }
  end

  def blocks_attributes
    { blocks_attributes: [:name, :id, fields_attributes] }
  end

  def fields_attributes
    { fields_attributes: [:acreage, :name, :soil_class_id, :id] }
  end
end
