class AddCompanyIdToUserInvitations < ActiveRecord::Migration
  def change
    add_column :user_invitations, :company_id, :integer
  end
end
