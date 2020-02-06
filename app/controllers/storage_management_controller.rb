class StorageManagementController < ApplicationController
  def index
    @locations = locations_list
  end

  private

  def locations_list
    FreezerLocation.page(params[:page]).order('name ASC')
  end
end
