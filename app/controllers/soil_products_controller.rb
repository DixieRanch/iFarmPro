class SoilProductsController < ApplicationController

  def index
    @product  = SoilProduct.new
    @products = SoilProduct.order('name')
  end

  def create
    @product  = SoilProduct.new(params[:soil_product])
    if @product.save
      flash[:success] = "product successfully added."
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
    @product  = SoilProduct.find(params[:id])
    if @product.update_attributes(params[:soil_product])
      flash[:success] = "Soil Product successfully updated."
      redirect_to soil_products_path
    else
      @products = SoilProduct.order('name')
      render :index
    end
  end
end