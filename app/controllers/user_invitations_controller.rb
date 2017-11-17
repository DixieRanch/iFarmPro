class UserInvitationsController < ApplicationController
  def new
    @invitation = UserInvitation.new
  end

  def create
    @invitation = UserInvitation.new

    if @invitation.save
      redirect_to root_path
    else
      render 'new'
    end
  end
end
