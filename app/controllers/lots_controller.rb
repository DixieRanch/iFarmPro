class LotsController < ApplicationController
  def new
    @lot = LotForm.new
    @lots = lots_list
  end

  def create
    @lot = LotForm.new(lot_params)
    @lots = lots_list
    if @lot.save
      flash[:success] = 'Lot successfully created'
      redirect_to new_lot_path
    else
      render :new
    end
  end

  def edit
    @lot = LotForm.find(params[:id])
    @lots = lots_list
    render :new
  end

  def update
    @lot = LotForm.find(params[:id])
    if @lot.update(lot_params)
      flash[:success] = 'Lot successfully updated'
      redirect_to new_lot_path
    else
      @lots = lots_list
      render :new
    end
  end

  private

  def lots_list
    Lot.page(params[:page]).order('name DESC')
  end

  def lot_params
    params.require(:lot).permit(permitted_params)
  end

  def permitted_params
    [:name, :full_weight, :freezer_location_id, :box_name, :block_id,
     :field_name, :content_id]
  end
end
