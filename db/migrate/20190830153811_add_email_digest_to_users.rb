class AddEmailDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_digest, :string
  end
end
