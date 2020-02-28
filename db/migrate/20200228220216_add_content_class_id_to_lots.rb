class AddContentClassIdToLots < ActiveRecord::Migration
  def change
    add_column :lots, :content_class_id, :int
    add_index  :lots, :content_class_id
  end
end
