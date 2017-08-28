class PasswordResetsController < ApplicationController
  
  skip_before_filter :signed_in_user
  
  def show
    @email = params[:id]
  end
  
  def new
    
  end
  
  def create
    UserMailer.password_reset(params[:password_reset][:email]).deliver_now
    redirect_to password_reset_path(params[:password_reset][:email])
  end
end