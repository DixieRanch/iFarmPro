class EmailChangesController < ApplicationController
  def new
  end

  def create
    if current_user.save
      current_user.update_attributes(
        new_email: params[:email_changes][:new_email]
      )
      render 'show'
    else
      flash[:danger] = 'Invalid Email Address'
      render 'new'
    end
  end
end
