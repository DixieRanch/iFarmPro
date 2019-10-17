class StorageLocationsController < ApplicationController
  def index
    @storage_location = FreezerLocation.new
  end
end
