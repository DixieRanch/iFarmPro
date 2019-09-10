class EmailChangesController < ApplicationController
  def new
  end

  def create
    current_user.update_attributes(
      new_email: params[:email_changes][:new_email]
    )
    render 'show'
  end
end
