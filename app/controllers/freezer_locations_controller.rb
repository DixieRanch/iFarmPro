class FreezerLocationsController < ApplicationController
  def index
    @freezer_location = FreezerLocation.new
    @freezer_locations = locations_list
  end

  def create
    @freezer_location =
      current_farm.freezer_locations.new(freezer_location_params)
    @freezer_locations = locations_list

    if @freezer_location.save
      flash[:success] = 'Location successfully created.'
      redirect_to freezer_locations_path
    else
      render :index
    end
  end

  def edit
    @freezer_location = FreezerLocation.find(params[:id])
    @freezer_locations = locations_list
    render :index
  end

  def update
    @freezer_location = FreezerLocation.find(params[:id])
    if @freezer_location.update(freezer_location_params)
      flash[:success] = 'Location successfully updated.'
      redirect_to freezer_locations_path
    else
      @freezer_locations = locations_list
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
    FreezerLocation.page(params[:page]).by_name_numerically
  end
end
