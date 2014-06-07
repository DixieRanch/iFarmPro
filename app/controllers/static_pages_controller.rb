class StaticPagesController < ApplicationController
  
  skip_before_filter :signed_in_user
  skip_before_filter :farm_setup

  def home
    if not signed_in?
    elsif Farm.all.empty?
      redirect_to new_farm_path
    elsif Field.all.empty?
      redirect_to edit_farm_path(Farm.first)
    else
      redirect_to report_path(:next_irrigations)
    end

  end

  def help
  end

  def about    
  end

  def contact    
  end
end