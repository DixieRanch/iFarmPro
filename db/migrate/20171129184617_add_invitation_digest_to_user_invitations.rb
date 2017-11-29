class AddInvitationDigestToUserInvitations < ActiveRecord::Migration
  def change
    add_column :user_invitations, :invitation_digest, :string
  end
end
