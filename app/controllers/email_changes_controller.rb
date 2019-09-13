class EmailChangesController < ApplicationController
  def show
    @email = params[:id]
  end

  def new
  end

  def create
    current_user.update_attributes(
      new_email: params[:email_changes][:new_email]
    )
    if current_user.save
      current_user.send_new_email_verification
      render 'show'
    else
      current_user.update_attributes(
        new_email: nil
      )
      flash[:danger] = 'Invalid Email Address'
      render 'new'
    end
  end

  def edit
  end
end
