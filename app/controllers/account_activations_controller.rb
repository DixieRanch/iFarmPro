class AccountActivationsController < ApplicationController
  skip_before_action :signed_in_user

  def show
    @email = params[:id]
  end

  def create
    user = User.with_email(params[:account_activation][:email])
    user.send_activation_email
    flash[:success] = "Activation email sucessfully sent.  Please check your
                       email for the link to activate your account."
    redirect_to account_activation_path(params[:account_activation][:email])
  end

  def edit
    user = User.with_email(params[:email])
    if user.authenticated?(:email, params[:id]) && user.activated? != true
      user.activate
      sign_in(user)
      flash[:success] = 'Account Activated!'
    else
      flash.now[:danger] = 'Invalid Activation Link'
      render 'new'
    end
  end
end
