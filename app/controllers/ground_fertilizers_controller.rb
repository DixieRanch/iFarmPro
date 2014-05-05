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

  def edit
    @fertilizer  = GroundFertilizer.find(params[:id])
    @fertilizers = GroundFertilizer.order('name')
    render :index
  end

  def update
    @fertilizer  = GroundFertilizer.find(params[:id])
    if @fertilizer.update_attributes(params[:ground_fertilizer])
      flash[:success] = "Soil Product successfully updated."
      redirect_to ground_fertilizers_path
    else
      @fertilizers = GroundFertilizer.order('name')
      render :index
    end
  end
end