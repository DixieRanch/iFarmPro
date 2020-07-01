class ChangeDateTypeInShipments < ActiveRecord::Migration
  def up
    change_column :shipments, :date, :date
  end
  
   def down
    change_column :shipments, :date, :datetime
  end
end
