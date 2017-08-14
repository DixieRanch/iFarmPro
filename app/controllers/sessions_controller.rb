class SessionsController < ApplicationController

  skip_before_filter :signed_in_user, only: [:new, :create]
  skip_before_filter :farm_setup, only: [:destroy]

  def new
    
  end

  def create
    email = params[:session][:email].downcase
    user = User.where('lower(email) = ?', email).first
    if user && user.authenticate(params[:session][:password])
      sign_in user
      UserMailer.account_activation(user).deliver_now # Email test, delete me.
      redirect_back_or root_path
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