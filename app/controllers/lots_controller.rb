class LotsController < ApplicationController
  def new
    @lot = LotForm.new
    @lots = lots_list
  end

  def create
    find_field_id_for(params[:lot][:field_name], params[:lot][:block_id])
    find_box_id_for(params[:lot][:box_name])
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
    find_box_id_for(params[:lot][:box_name])
    find_field_id_for(params[:lot][:field_name], params[:lot][:block_id])
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
    [:name, :full_weight, :freezer_location_id, :box_id, :block_id, :field_id,
     :content_id]
  end

  def find_box_id_for(box_name)
    params[:lot][:box_id] = if Box.find_by(name: box_name)
                              Box.find_by(name: box_name).id
                            end
  end

  def find_field_id_for(field, block)
    params[:lot][:field_id] = if Field.find_by(name: field, block_id: block)
                                Field.find_by(name: field, block_id: block).id
                              end
  end
end
