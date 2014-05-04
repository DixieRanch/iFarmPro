class GroundFertilizersController < ApplicationController

  def index
    @fertilizer  = GroundFertilizer.new
    @fertilizers = GroundFertilizer.order('name')
  end

  def create
    @fertilizer  = GroundFertilizer.new(params[:ground_fertilizer])
    if @fertilizer.save
      flash[:success] = "Fertilizer successfully added."
      redirect_to ground_fertilizers_path
    else
      @fertilizers = GroundFertilizer.order('name')
      render :index
    end
  end
end