class StorageLocationsController < ApplicationController
  def index
    @storage_location = FreezerLocation.new
  end

  def create
    farm = current_farm
    @storage_location = farm.freezer_locations.new(freezer_location_params)
    redirect_to storage_locations_path if @storage_location.save!
  end

  private

  def freezer_location_params
    params.require(:freezer_location).permit(permitted_params)
  end

  def permitted_params
    [:name]
  end
end
