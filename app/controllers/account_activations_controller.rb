class AccountActivationsController < ApplicationController

  skip_before_filter :signed_in_user

  def edit
    user = User.where('lower(email) = ?', params[:email].downcase).first
    if user && user.authenticated?(:activation, params[:id])
      user.activate
    end
    redirect_to signin_path
  end
end