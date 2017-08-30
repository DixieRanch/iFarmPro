class PasswordResetsController < ApplicationController
  
  skip_before_filter :signed_in_user
  
  def show
    @email = params[:id]
  end
  
  def new
    
  end
  
  def create
    email = params[:password_reset][:email]
    user = User.find_by(email: email)
    user.send_password_reset_email if user
    # UserMailer.password_reset(params[:password_reset][:email]).deliver_now
    # redirect_to password_reset_path(params[:password_reset][:email])
    redirect_to password_reset_path(email)
  end
  
  def edit
    @user = params[:id]
  end
end