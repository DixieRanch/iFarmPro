class CreateUserInvitation < ActiveRecord::Migration
  def change
    create_table :user_invitations do |t|
      t.string :email
      
      t.timestamps
    end
  end
end
