class UserInvitationsController < ApplicationController
  skip_before_action :signed_in_user, only: [:edit, :update]

  def new
    @invitation = UserInvitation.new
  end

  def create
    @invitation = UserInvitation.new(invitation_params)

    if @invitation.save
      @invitation.send_invitation_email
      flash[:success] = 'Invitation has been sent'
      redirect_to root_path
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
    @invitation = UserInvitation.with_email(params[:user_invitation][:email])

    if !@invitation.authenticated?(:invitation, params[:id])
      redirect_to root_path
      flash[:danger] = 'Your invitation has expired.  Request
                        a new one from your company.'

    elsif @invitation.invitation_expired?
      redirect_to root_path
      flash[:danger] = 'Your invitation has expired.  Request
                        a new one from your company.'

    elsif params[:user_invitation][:password].present?
      @user = User.new(user_params)
      @user.company_id = @invitation.company_id
      @user.save
      @user.activate
      sign_in(@user)
      flash[:success] = 'Welcome to iFarmPro!'

    else
      render 'edit'
    end
  end

  private

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
