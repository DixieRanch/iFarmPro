# == Schema Information
#
# Table name: rains
#
#  id         :integer          not null, primary key
#  date       :date
#  amount     :decimal(, )
#  farm_id    :integer
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class RainsController < ApplicationController
  def index
    @rains = rain_list
    @rain = Rain.new
  end

  def edit
    @rains = rain_list
    @rain = Rain.find(params[:id])
  end

  def create
    @rain = Rain.new(rain_params)
    farm = Farm.all.first
    @rain.farm = farm
    if @rain.save
      redirect_to rains_path
    else
      @rains = rain_list
    end
  end

  def update
    @rain = Rain.find(params[:id])
    if @rain.update(rain_params)
      redirect_to rains_path
    else
      @rains = rain_list
    end
  end

  private

  def rain_list
    Rain.page(params[:page]).per_page(30).order('date desc')
  end

  def rain_params
    params.require(:rain).permit(permitted_params)
  end

  def permitted_params
    [:amount, :date]
  end
end
