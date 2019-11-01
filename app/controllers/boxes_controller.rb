class BoxesController < ApplicationController
  def index
    @boxes = Box.page(params[:page]).order('name DESC')
    @box = Box.new
  end

  def create
    @box = current_company.boxes.new(box_params)
    @boxes = Box.page(params[:page]).order('name DESC')
    if @box.save
      flash[:success] = 'Container successfully created.'
      redirect_to boxes_path
    else
      render :index
    end
  end

  def edit
    @box = current_company.boxes.find(params[:id])
    render_box_page
  end

  def update
    @box = current_company.boxes.find(params[:id])

    if @box.update(box_params)
      flash[:success] = 'Container successfully updated.'
      redirect_to boxes_path
    else
      render_box_page
    end
  end

  private

  def box_params
    params.require(:box).permit(permitted_params)
  end

  def permitted_params
    [:name, :empty_weight]
  end

  def render_box_page
    @boxes = Box.page(params[:page]).order('name DESC')
    render :index
  end
end
