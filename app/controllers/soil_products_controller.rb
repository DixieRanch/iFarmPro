# == Schema Information
#
# Table name: soil_products
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  n          :integer
#  p          :integer
#  k          :integer
#  s          :integer
#  created_at :datetime
#  updated_at :datetime
#

class SoilProductsController < ApplicationController
  def index
    @product  = SoilProduct.new
    @products = SoilProduct.order('name')
  end

  def create
    @product  = SoilProduct.new(soil_product_params)
    if @product.save
      flash[:success] = 'product successfully added.'
      redirect_to soil_products_path
    else
      @products = SoilProduct.order('name')
      render :index
    end
  end

  def edit
    @product  = SoilProduct.find(params[:id])
    @products = SoilProduct.order('name')
    render :index
  end

  def update
    @product = SoilProduct.find(params[:id])
    if @product.update(soil_product_params)
      flash[:success] = 'Soil Product successfully updated.'
      redirect_to soil_products_path
    else
      @products = SoilProduct.order('name')
      render :index
    end
  end

  private

  def soil_product_params
    params.require(:soil_product).permit(permitted_params)
  end

  def permitted_params
    [:name, :n, :p, :k, :s]
  end
end
