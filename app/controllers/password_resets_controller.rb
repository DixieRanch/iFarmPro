class PasswordResetsController < ApplicationController
  skip_before_action :signed_in_user

  def show
    @email = params[:id]
  end

  def new
  end

  def create
    user = User.find_by(email: params[:password_reset][:email])

    if user.nil?
      redirect_to password_reset_path(params[:password_reset][:email])
    else
      user.send_password_reset_email
      redirect_to password_reset_path(user.email)
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
    if !@user.activated? && @user.authenticated?(:password_reset, params[:id])
      @user.activate
    end
  end

  def update
    @user = User.find_by(email: params[:user][:email])

    if @user.nil? || !@user.authenticated?(:password_reset, params[:id])
      redirect_to password_reset_path(@user.email)
    elsif @user.password_reset_sent_at < 2.hours.ago
      flash[:danger] = 'Expired Password Reset!  Request a new one.'
      redirect_to new_password_reset_path
    elsif @user.update(user_params)
      sign_in(@user)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.require(:user).permit(permitted_params)
  end

  def permitted_params
    [:password, :password_confirmation]
  end
end
