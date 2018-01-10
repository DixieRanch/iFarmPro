class UserInvitationsController < ApplicationController
  skip_before_action :signed_in_user, only: [:edit]

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
  end

  def update
    @invitation = UserInvitation.with_email(params[:user_invitation][:email])

    render 'edit'
  end

  private

  def invitation_params
    params.require(:user_invitation).permit([:email])
  end
end
