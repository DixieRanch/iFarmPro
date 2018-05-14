class AddInvitationTokenSentAtToUserInvitation < ActiveRecord::Migration
  def change
    add_column :user_invitations, :invitation_sent_at, :datetime
  end
end
