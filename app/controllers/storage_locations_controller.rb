class StorageLocationsController < ApplicationController
  def new
    @storage_location = FreezerLocation.new
  end
end
