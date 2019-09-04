class RemovePasswordResetSentAtFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :password_reset_sent_at, :string
  end
  
  def down
    add_column    :users, :password_reset_sent_at, :string
  end
end
