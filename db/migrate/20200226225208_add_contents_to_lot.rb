class AddContentsToLot < ActiveRecord::Migration
  def change
    add_column :lots, :contents, :string
  end
end
