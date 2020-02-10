class StorageManagementController < ApplicationController
  def index
    @locations = locations_list
    @total_net_weight = total_net_weight
    @total_lot_count = total_lot_count
  end

  private

  def locations_list
    FreezerLocation.page(params[:page]).order('name ASC')
  end

  def total_net_weight
    Lot.all.map(&:net_weight).sum
  end

  def total_lot_count
    Lot.all.count
  end
end
