class RainsController < ApplicationController

  def index
    get_rains
    @rain = Rain.new
  end

  def edit
    get_rains
    @rain = Rain.find(params[:id])
    render :index
  end

  def create
    @rain = Rain.new(params[:rain])
    farm = Farm.all().first()
    @rain.farm = farm
    if @rain.save
      redirect_to rains_path
    else
      flash[:error] = 'Failed to create rain entry!'
      get_rains
    end
  end

  # def update
  #   @rains = Rain.order('date')
  #   @rain = Rain.find(params[:id])
  # end

  private

  # TODO: write a controller test for this?
  def get_rains
    @rains = Rain.order('date')
  end

end
