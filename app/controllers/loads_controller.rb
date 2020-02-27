require 'will_paginate/array'
class LoadsController < ApplicationController
  def index
    @loads = Load.all.paginate(page: params[:page], per_page: 30)
    @totals = totals(@loads)
  end

  def edit
    @load = Load.new(FreezerLocation.find_by(id: params[:id]))
    @locations = FreezerLocation.all.by_name_numerically
  end

  def update
    @load = Load.new(FreezerLocation.find_by(id: params[:id]))
    new_location = FreezerLocation.find_by(id: params[:load][:location])
    @load.move(new_location)
    redirect_to loads_path
  end

  private

  def totals(loads)
    weight = 0
    count = 0

    loads.each do |ld|
      weight += ld.lots.all.map(&:net_weight).sum
      count += ld.lots.all.count
    end
    { weight: weight, count: count }
  end
end
