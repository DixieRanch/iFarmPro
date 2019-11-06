class LotsController < ApplicationController
  def index
    @lots = Lot.all # lots_list
  end

  private

  def lots_list
    Lot.page(params[:page]).order('name ASC')
  end
end
