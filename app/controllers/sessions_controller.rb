class SessionsController < ApplicationController

  skip_before_filter :signed_in_user, only: [:new, :create]

  def new
    
  end

  def create
    email = params[:session][:email].downcase
    user = User.where('lower(email) = ?', email).first
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user.company
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end