class LotsController < ApplicationController
  def index
    @lot = Lot.new
    @lots = lots_list
  end

  def create
    @lot = Lot.new(lot_params)
    @lots = lots_list
    render :index
  end

  def edit
    @lots = lots_list
    render :index
  end

  private

  def lots_list
    Lot.page(params[:page]).order('name ASC')
  end

  def lot_params
    params.require(:lot).permit(permitted_params)
  end

  def permitted_params
    [:name, :full_weight, :box_id, :block_id, :field_id]
  end
end
