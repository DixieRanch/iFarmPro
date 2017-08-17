class AccountActivationsController < ApplicationController

  skip_before_filter :signed_in_user

  def edit
    user = User.where('lower(email) = ?', params[:email].downcase).first
    if user && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in(user)
    end
    redirect_to root_path
  end
end