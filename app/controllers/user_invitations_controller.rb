class UserInvitationsController < ApplicationController
<<<<<<< 6e6a2735e781d96d3fd4e8e6bd1631672ad42367
<<<<<<< 7a044c75975761ed3e0e097605244ae23bf614df
=======
>>>>>>> Add email link to form for completing invitation signup
  skip_before_action :signed_in_user, only: [:edit]

  def new
    @invitation = UserInvitation.new
  end

  def create
<<<<<<< 4fc6b24b6291815c9cd018918c1fbc4f29f73e66
<<<<<<< cfefa529eda5b5f0f7de192cdefd7b86cfdfe062
    @invitation = UserInvitation.new(invitation_params)

    if @invitation.save
      @invitation.send_invitation_email
      flash[:success] = 'Invitation has been sent'
=======
    @invitation = UserInvitation.new
=======
    @invitation = UserInvitation.new(invitation_params)
<<<<<<< debd56ad73c7525acc7896b091e42821718f7627
    puts params
>>>>>>> Add params to user_invitations_controller for creating invitations
=======
>>>>>>> Remove puts statement from user_invitations controller

    if @invitation.save
<<<<<<< 278158dee96358fd10462c603a27b11a65eba5d7
<<<<<<< 0ab80bd4f3405d84a8fb2ed0cdf0f3fe0b818afa
>>>>>>> Add form to submit email for invitations then redirect to schedule
=======
=======
      @invitation.send_invitation_email
>>>>>>> Add email sending functionality to user invitations
      flash[:success] = 'Invitation has been sent'
>>>>>>> Add flash message upon successful form submission
      redirect_to root_path
    else
      render 'new'
    end
  end
<<<<<<< 4fc6b24b6291815c9cd018918c1fbc4f29f73e66
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
=======
>>>>>>> Add params to user_invitations_controller for creating invitations

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
<<<<<<< 4fc6b24b6291815c9cd018918c1fbc4f29f73e66
end
=======
  def new
  end
end
>>>>>>> Add basic file structure for new user invitations
=======
=======
>>>>>>> Add params to user_invitations_controller for creating invitations
end
>>>>>>> Add form to submit email for invitations then redirect to schedule
