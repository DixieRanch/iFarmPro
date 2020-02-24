require 'will_paginate/array'
class LoadsController < ApplicationController
  def index
    @loads = Load.all.paginate(page: params[:page], per_page: 30)
    @totals = totals(@loads)
  end

  def edit
    @current_location = FreezerLocation.find(params[:id])
    @locations = FreezerLocation.all.by_name_numerically
  end

  private

  def locations_list
    FreezerLocation.page(params[:page]).by_name_numerically
  end

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
