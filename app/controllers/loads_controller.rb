require 'will_paginate/array'
class LoadsController < ApplicationController
  def index
    @loads = Load.all.paginate(page: params[:page], per_page: 30)
    @total_net_weight = total_net_weight(@loads)
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

  def total_net_weight(loads)
    weight = 0
    loads.each do |ld|
      weight += ld.lots.all.map(&:net_weight).sum
    end
    weight
  end

  def total_lot_count
    Lot.all.count
  end
end
