class PasswordResetsController < ApplicationController
  
  skip_before_filter :signed_in_user
  
  def show
    @email = params[:id]
  end
  
  def new
    
  end
  
  def create
    user = User.find_by_email(params[:password_reset][:email])
    UserMailer.password_reset(user).deliver_now
    redirect_to password_reset_path(user.email)
  end
  
  def edit
    
  end
end