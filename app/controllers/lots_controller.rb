class LotsController < ApplicationController
  def index
    @lot = Lot.new
    @lots = lots_list
  end

  def create
    find_box_id_for(params[:lot][:box_id])
    @lot = Lot.new(lot_params)
    @lots = lots_list
    if @lot.save
      flash[:success] = 'Lot successfully created'
      redirect_to lots_path
    else
      render :index
    end
  end

  def edit
    @lot = Lot.find(params[:id])
    find_box_name_for(@lot)
    @lots = lots_list
    render :index
  end

  def update
    find_box_id_for(params[:lot][:box_id])
    @lot = Lot.find(params[:id])

    if @lot.update(lot_params)
      flash[:success] = 'Lot successfully updated'
      redirect_to lots_path
    else
      @lots = lots_list
      render :index
    end
  end

  private

  def lots_list
    Lot.page(params[:page]).order('name ASC')
  end

  def lot_params
    params.require(:lot).permit(permitted_params)
  end

  def permitted_params
    [:name, :full_weight, :freezer_location_id, :box_id, :block_id, :field_id]
  end

  def find_box_id_for(box_name)
    params[:lot][:box_id] = if Box.find_by(name: box_name)
                              Box.find_by(name: box_name).id
                            end
  end

  def find_box_name_for(lot)
    @lot.box_id = Box.find_by(id: lot.box_id).name
  end
end
