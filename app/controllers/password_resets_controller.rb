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
    @email = email
    @user = user
    
    check_existance
  end
  
  def edit
    @user = User.find_by(email: params[:email])
  end
  
  def update
    @user = User.find_by(email: params[:user][:email])
    
    check_authentication
  end
  
  
  private
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def check_existance
      if @user
        check_activation
      else
        redirect_to password_reset_path(@email)
      end
    end
    
    def check_activation
      if @user.activated?
        send_email
      else
        redirect_to account_activation_path(@email)
      end
    end
    
    def send_email
      @user.send_password_reset_email
      redirect_to password_reset_path(@email)
    end
    
    def check_authentication
      if @user && @user.authenticated?(:password_reset, params[:id])
        check_expiration
        
      else
        redirect_to password_reset_path(email: params[:user][:email])
      end
    end
    
    def check_expiration
      if @user.password_reset_sent_at > 2.hours.ago
        check_validation
      
      else
        is_expired
      end
    end
    
    def is_expired
      flash[:danger] = "Expired Password Reset!  Request a new one."
      redirect_to new_password_reset_path
    end
    
    def check_validation
      if @user.update(user_params)
        login
      else
        render 'edit'
      end
    end
    
    def login
      sign_in(@user)
      redirect_to root_path
    end
    
    def user_params
      params.require(:user).permit(permitted_params)
    end
    
    def permitted_params
      [:password, :password_confirmation]
    end
end