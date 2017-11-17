class UserInvitationsController < ApplicationController
<<<<<<< 7a044c75975761ed3e0e097605244ae23bf614df
  skip_before_action :signed_in_user, only: [:edit]

  def new
    @invitation = UserInvitation.new
  end

  def create
<<<<<<< cfefa529eda5b5f0f7de192cdefd7b86cfdfe062
    @invitation = UserInvitation.new(invitation_params)

    if @invitation.save
      @invitation.send_invitation_email
      flash[:success] = 'Invitation has been sent'
=======
    @invitation = UserInvitation.new

    if @invitation.save
<<<<<<< 0ab80bd4f3405d84a8fb2ed0cdf0f3fe0b818afa
>>>>>>> Add form to submit email for invitations then redirect to schedule
=======
      flash[:success] = 'Invitation has been sent'
>>>>>>> Add flash message upon successful form submission
      redirect_to root_path
    else
      render 'new'
    end
  end
<<<<<<< cfefa529eda5b5f0f7de192cdefd7b86cfdfe062

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
=======
  def new
  end
end
>>>>>>> Add basic file structure for new user invitations
=======
end
>>>>>>> Add form to submit email for invitations then redirect to schedule
