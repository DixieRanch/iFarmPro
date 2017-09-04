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
    @user = User.find_by(email: params[:email])
  end
  
  def update
    @user = User.find_by(email: params[:user][:email])
    if @user.password_reset_sent_at > 2.hours.ago
     # Authenticate user against reset token
     # Save the user(update the password)
     # Sign in user
     # Redirect to root_path
    else
      flash[:danger] = "Expired Password Reset!  Request a new one."
      redirect_to new_password_reset_path
    end
  end
  
  private
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Expired password reset!"
        redirect_to new_password_reset_path
      end
    end
end