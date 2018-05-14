class UserInvitationsController < ApplicationController
  skip_before_action :signed_in_user, only: [:edit, :update]
  before_action :find_record, only: [:update]

  def new
    @invitation = UserInvitation.new
  end

  def create
    @invitation = UserInvitation.new(invitation_params)

    if @invitation.save
      send_invitation

    elsif !User.where(email: @invitation.email).exists?
      invitation = UserInvitation.with_email(@invitation.email)
      invitation.destroy
      send_invitation if @invitation.save

    else
      render 'new'
    end
  end

  def edit
    @invitation = UserInvitation.with_email(params[:email])

    return unless @invitation.invitation_expired?
    redirect_to root_path
    flash[:danger] = 'Your invitation has expired.  Request
                      a new one from your company.'
  end

  def update
    if !@invitation.authenticated?(:invitation, params[:id])
      handle_expired
    elsif @invitation.invitation_expired?
      handle_expired
    elsif params[:user_invitation][:password].present?
      setup_user
    else
      render 'edit'
    end
  end

  private

  def find_record
    @invitation = UserInvitation.with_email(params[:user_invitation][:email])
  end

  def send_invitation
    @invitation.send_invitation_email
    flash[:success] = 'Invitation has been sent'
    redirect_to root_path
  end

  def handle_expired
    redirect_to root_path
    flash[:danger] = 'Your invitation has expired.  Request
                      a new one from your company.'
  end

  def complete_signup
    @user.activate
    sign_in(@user)
    flash[:success] = 'Welcome to iFarmPro!'
    @invitation.destroy
  end

  def setup_user
    @user = User.new(user_params)
    @user.company_id = @invitation.company_id
    if @user.save
      complete_signup
    else
      render 'edit'
    end
  end

  def invitation_params
    params.require(:user_invitation).permit(permitted_params)
  end

  def permitted_params
    [:email, :company_id]
  end

  def user_params
    params.require(:user_invitation).permit(user_permitted_params)
  end

  def user_permitted_params
    [:email, :password, :password_confirmation, :company_id]
  end
end
