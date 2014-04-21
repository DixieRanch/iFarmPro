class RainsController < ApplicationController
  def index
    get_rains
  end

  def edit
    get_rains
  end

  private

  def get_rains
    @rains = Rain.order('date')
  end

end


