class RemoveActivationDigestFromUsers < ActiveRecord::Migration
  def up
    remove_column     :users, :activation_digest
  end
  
  def down
    add_column        :users, :activation_digest, :string
  end
end
