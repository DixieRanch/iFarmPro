class FarmsController < ApplicationController

  def index
    @farms = Farm.all
  end

  def show
    @farm = Farm.find(params[:id])
  end

  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(params[:farm])
    if @farm.save
      flash[:success] = "New farm successfully added."
      redirect_to farms_path
    else
      render 'new'
    end
  end

  def edit
    @farm = Farm.find(params[:id])
  end

  def update
    @farm = Farm.find(params[:id])
    if @farm.update_attributes(params[:farm])
      flash[:success] = "Updated"
      redirect_to @farm
    else
      render 'edit'
    end
  end

end