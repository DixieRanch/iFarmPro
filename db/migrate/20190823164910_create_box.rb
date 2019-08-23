class CreateBox < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.integer :box_id
      t.integer :empty_weight
      t.integer :company_id
      
      t.timestamps
    end
    add_index :boxes, :box_id
    add_index :boxes, :company_id
  end
end
