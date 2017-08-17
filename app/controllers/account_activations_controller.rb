class AccountActivationsController < ApplicationController

  skip_before_filter :signed_in_user

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