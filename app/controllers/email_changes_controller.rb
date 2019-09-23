class EmailChangesController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = current_user
    assign_new_email_attribute_to(@user)
    send_new_email_verification_or_display_form_errors_for(@user)
  end

  private

  def assign_new_email_attribute_to(user)
    user.new_email = params[:user][:new_email]
  end

  def send_new_email_verification_or_display_form_errors_for(user)
    User.skip_callback(:save, :before, :create_remember_token)
    if user.save
      user.send_new_email_verification
      redirect_to email_change_path(params[:user][:new_email])
    else
      flash[:danger] = 'Invalid Email Address'
      render 'email_changes/new'
    end
    User.set_callback(:save, :before, :create_remember_token)
  end
end
