class StorageLocationsController < ApplicationController
  def index
    @storage_location = FreezerLocation.new
    @storage_locations = locations_list
  end

  def create
    farm = current_farm
    @storage_location = farm.freezer_locations.new(freezer_location_params)
    @storage_locations = locations_list

    if @storage_location.save
      redirect_to storage_locations_path
    else
      flash[:danger] = 'Name cannot be blank'
      render :index
    end
  end

  private

  def freezer_location_params
    params.require(:freezer_location).permit(permitted_params)
  end

  def permitted_params
    [:name]
  end

  def locations_list
    FreezerLocation.page(params[:page]).order('')
  end
end
