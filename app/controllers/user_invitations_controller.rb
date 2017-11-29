class UserInvitationsController < ApplicationController
  def new
    @invitation = UserInvitation.new
  end

  def create
    @invitation = UserInvitation.new(invitation_params)

    if @invitation.save
      flash[:success] = 'Invitation has been sent'
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def invitation_params
    params.require(:user_invitation).permit([:email])
  end
end
