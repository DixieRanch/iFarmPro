class EmailChangesController < ApplicationController
  def show
    @email = params[:id]
  end

  def new
  end

  def create
    current_user.new_email = params[:email_changes][:new_email]
    if current_user.valid?
      valid_email
    else
      invalid_email
    end
  end

  private

  def valid_email
    current_user.update_attributes(
      new_email: params[:email_changes][:new_email]
    )
    current_user.send_new_email_verification
    render 'show'
  end

  def invalid_email
    current_user.update_attributes(new_email: nil)
    flash[:danger] = 'Invalid Email Address'
    render 'new'
  end
end
