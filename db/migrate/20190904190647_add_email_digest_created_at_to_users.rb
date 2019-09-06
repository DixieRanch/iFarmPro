class AddEmailDigestCreatedAtToUsers < ActiveRecord::Migration
  def up
    add_column    :users, :email_digest_created_at, :string
  end
  
  def down
    remove_column :users, :email_digest_created_at, :string
  end
end
