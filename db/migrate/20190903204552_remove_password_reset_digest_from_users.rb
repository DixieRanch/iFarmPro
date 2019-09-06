class RemovePasswordResetDigestFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :password_reset_digest
  end
  
  def down
    add_column    :users, :password_reset_digest, :string
  end
end
