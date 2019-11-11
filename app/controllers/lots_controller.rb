class LotsController < ApplicationController
  def index
    @lot = Lot.new
    @lots = lots_list
  end

  def edit
    @lots = lots_list
    render :index
  end

  private

  def lots_list
    Lot.page(params[:page]).order('name ASC')
  end
end
