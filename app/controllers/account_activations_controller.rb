class AccountActivationsController < ApplicationController

  skip_before_filter :signed_in_user
  
  def create
    email = params[:account_activation][:email]
    user = User.find_by(email: email)
    user.send_activation_email if user
    flash[:success] = "Activation email sucessfully sent.  Please check your
                       email for the link to activate your account."
    redirect_to root_path
  end

  def edit
    user = User.where('lower(email) = ?', params[:email].downcase).first
    if user && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in(user)
      flash[:success] = "Account Activated!"
      redirect_to root_path unless farm_setup
    else
      flash.now[:danger] = "Invalid Activation Link"
      render 'new'
    end
  end
end