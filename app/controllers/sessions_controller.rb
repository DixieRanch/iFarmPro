class SessionsController < ApplicationController
  skip_before_action :signed_in_user, only: [:new, :create]
  skip_before_action :farm_setup, only: [:destroy]

  def new
  end

  def create
    user = User.with_email(params[:session][:email])
    if user.authenticated?(:password, params[:session][:password])
      sign_in user
      redirect_back_or root_path if user.activated?
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
