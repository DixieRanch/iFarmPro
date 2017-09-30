class StaticPagesController < ApplicationController
  skip_before_action :signed_in_user

  def home
    redirect_to report_path(:next_irrigations) if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
