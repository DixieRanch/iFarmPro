class BoxesController < ApplicationController
  def index
    @containers = Box.page(params[:page]).order('name DESC')
  end
end
