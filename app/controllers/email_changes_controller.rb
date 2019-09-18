class EmailChangesController < ApplicationController
  # def show
  #   @email = params[:id]
  # end

  def new
    @user = User.new
  end

  def create
    @user = current_user
    @user.new_email = params[:user][:new_email]
    User.skip_callback(:save, :before, :create_remember_token)
    if @user.save
      @user.send_new_email_verification
      redirect_to email_change_path(params[:user][:new_email])
    else
      flash[:danger] = 'Invalid Email Address'
      render 'email_changes/new'
    end
    User.set_callback(:save, :before, :create_remember_token)
    # current_user.new_email = params[:email_changes][:new_email]

    # if current_user.save
    #   update_new_email_and_send_verification_email
    # else
    # render_email_form_with_invalid_email_flash
    # end
  end

  private

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def new_email_is_valid?
    params[:email_changes][:new_email][VALID_EMAIL_REGEX]
  end

  def update_new_email_and_send_verification_email
    # current_user.update_attributes(
    #   new_email: params[:email_changes][:new_email]
    # )
    current_user.send_new_email_verification
  end

  def render_email_form_with_invalid_email_flash
  end
end
