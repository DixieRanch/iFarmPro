class PasswordResetsController < ApplicationController
  skip_before_action :signed_in_user

  def show
    @email = params[:id]
  end

  def new
  end

  def create
    user = User.with_email(params[:password_reset][:email])

    user.send_password_reset_email
    redirect_to password_reset_path(params[:password_reset][:email])
  end

  def edit
    @user = User.with_email(params[:email])
    @user.activate if @user.authenticated?(:password_reset, params[:id])

    return unless @user.password_reset_expired?
    flash[:danger] = 'Expired Password Reset link!  Request a new one.'
    redirect_to new_password_reset_path
  end

  def update
    @user = User.with_email(params[:user][:email])

    if !@user.authenticated?(:password_reset, params[:id])
      redirect_to password_reset_path(@user.email)
    elsif @user.password_reset_expired?
      flash[:danger] = 'Expired Password Reset!  Request a new one.'
      redirect_to new_password_reset_path
    elsif params[:user][:password].present? && @user.update(user_params)
      sign_in(@user)
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(permitted_params)
  end

  def permitted_params
    [:password, :password_confirmation]
  end
end
