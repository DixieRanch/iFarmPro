class AccountActivationsController < ApplicationController
  skip_before_action :signed_in_user

  def show
    @email = params[:id]
  end

  def create
    email = params[:account_activation][:email]
    user = User.find_by(email: email) || NullUser.new
    user.send_activation_email
    flash[:success] = "Activation email sucessfully sent.  Please check your
                       email for the link to activate your account."
    redirect_to account_activation_path(email)
  end

  def edit
    user = User.with_email(params[:email]) || NullUser.new
    if user.authenticated?(:activation, params[:id])
      user.activate
      sign_in(user)
      flash[:success] = 'Account Activated!'
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid Activation Link'
      render 'new'
    end
  end
end
