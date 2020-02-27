require 'will_paginate/array'
class LoadsController < ApplicationController
  def index
    @loads = Load.all.paginate(page: params[:page], per_page: 30)
    @totals = totals_for_all_loads
  end

  def edit
    @load = Load.new(FreezerLocation.find_by(id: params[:id]))
    @locations = FreezerLocation.all.by_name_numerically
  end

  def update
    @load = Load.new(FreezerLocation.find_by(id: params[:id]))
    new_location = FreezerLocation.find_by(id: params[:load][:location])
    @load.move_to(new_location)
    redirect_to loads_path
  end

  private

  def totals_for_all_loads
    weight = 0
    count = 0

    Load.all.each do |ld|
      weight += ld.lots.all.map(&:net_weight).sum
      count += ld.lots.all.count
    end
    { weight: weight, count: count }
  end
end
