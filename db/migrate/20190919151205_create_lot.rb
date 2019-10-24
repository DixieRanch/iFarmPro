class CreateLot < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.string :name
      t.integer :full_weight
      t.integer :company_id
      t.integer :box_id
      t.integer :freezer_location_id
      t.integer :block_id
      t.integer :field_id
      
      t.timestamps
    end
  end
end
