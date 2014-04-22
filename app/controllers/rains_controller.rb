class RainsController < ApplicationController

  def index
    get_rains
  end

  def edit
    get_rains
    @rain = Rain.find(params[:id])
  end

  private

  # TODO: write a controller test for this?
  def get_rains
    @rains = Rain.order('date')
  end

end
