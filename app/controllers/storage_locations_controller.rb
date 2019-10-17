class StorageLocationsController < ApplicationController
  def index
    @storage_location = FreezerLocation.new
  end

  def create
    @storage_location = FreezerLocation.new
    render :index
  end
end
