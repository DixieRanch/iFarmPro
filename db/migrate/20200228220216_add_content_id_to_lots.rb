class AddContentIdToLots < ActiveRecord::Migration
  def change
    add_column :lots, :content_id, :int
    add_index  :lots, :content_id
  end
end
