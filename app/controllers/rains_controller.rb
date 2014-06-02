class RainsController < ApplicationController

  def index
    get_rains
    @rain = Rain.new
  end

  def edit
    get_rains
    @rain = Rain.find(params[:id])
  end

  def create
    @rain = Rain.new(rain_params)
    farm = Farm.all().first()
    @rain.farm = farm
    if @rain.save
      redirect_to rains_path
    else
      get_rains
    end
  end

  def update
    @rain = Rain.find(params[:id])
    if @rain.update(rain_params)
      redirect_to rains_path
    else
      get_rains
    end
  end

private

    # TODO: write a controller test for this?
    def get_rains
      @rains = Rain.order('date desc')
    end

    def rain_params
      params.require(:rain).permit(permitted_params)
    end

    def permitted_params
      [:amount, :date]
    end
end