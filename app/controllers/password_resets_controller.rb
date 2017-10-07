class PasswordResetsController < ApplicationController
  skip_before_action :signed_in_user

  def show
    @email = params[:id]
  end

  def new
  end

  def create
    user = User.find_by(email: params[:password_reset][:email])

    check_existance(user)
  end

  def edit
    @user = User.find_by(email: params[:email])
  end

  def update
    @user = User.find_by(email: params[:user][:email])

    check_authentication(@user)
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def check_existance(user)
    if user
      check_activation(user)
    else
      redirect_to password_reset_path(params[:password_reset][:email])
    end
  end

  def check_activation(user)
    if user.activated?
      send_email(user)
    else
      redirect_to account_activation_path(user.email)
    end
  end

  def send_email(user)
    user.send_password_reset_email
    redirect_to password_reset_path(user.email)
  end

  def check_authentication(user)
    if user && user.authenticated?(:password_reset, params[:id])
      check_expiration(user)

    else
      redirect_to password_reset_path(user.email)
    end
  end

  def check_expiration(user)
    if user.password_reset_sent_at > 2.hours.ago
      check_validation(user)

    else
      is_expired
    end
  end

  def is_expired
    flash[:danger] = 'Expired Password Reset!  Request a new one.'
    redirect_to new_password_reset_path
  end

  def check_validation(user)
    if user.update(user_params)
      login(user)
    else
      render 'edit'
    end
  end

  def login(user)
    sign_in(user)
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(permitted_params)
  end

  def permitted_params
    [:password, :password_confirmation]
  end
end
