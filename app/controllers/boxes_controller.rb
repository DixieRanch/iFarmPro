class BoxesController < ApplicationController
  def index
    @containers = Box.page(params[:page]).order('name DESC')
    @box = Box.new
  end

  def create
    @box = current_company.boxes.new(box_params)
    @containers = Box.page(params[:page]).order('name DESC')
    if @box.save
      flash[:success] = 'Container successfully created.'
      redirect_to boxes_path
    else
      render :index
    end
  end

  def edit
    @box = current_company.boxes.find(params[:id])
    @containers = Box.page(params[:page]).order('name DESC')
    render :index
  end

  def update
    @box = current_company.boxes.find(params[:id])

    if @box.update(box_params)
      flash[:success] = 'Container successfully updated.'
      redirect_to boxes_path
    else
      @containers = Box.page(params[:page]).order('name DESC')
    end
  end

  private

  def box_params
    params.require(:box).permit(permitted_params)
  end

  def permitted_params
    [:name, :empty_weight]
  end
end
