class LoadsController < ApplicationController
  def index
    @locations = locations_list
    @total_net_weight = total_net_weight
    @total_lot_count = total_lot_count
  end

  def edit
    @current_location = FreezerLocation.find(params[:id])
    @locations = FreezerLocation.all.by_name_numerically
  end

  private

  def locations_list
    FreezerLocation.page(params[:page]).by_name_numerically
  end

  def total_net_weight
    Lot.all.map(&:net_weight).sum
  end

  def total_lot_count
    Lot.all.count
  end
end
