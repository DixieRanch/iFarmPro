class PasswordResetsController < ApplicationController
  
  skip_before_filter :signed_in_user
  
  def show
    @email = params[:id]
  end
  
  def new
    
  end
  
  def create
    user = User.find_by_email(params[:password_reset][:email])
    user.send_password_reset_email if user
    redirect_to password_reset_path(params[:password_reset][:email])
  end
  
  def edit
    
  end
end