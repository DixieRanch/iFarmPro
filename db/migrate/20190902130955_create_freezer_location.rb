class CreateFreezerLocation < ActiveRecord::Migration
  def change
    create_table :freezer_locations do |t|
      t.string :name
      t.integer :farm_id
      t.integer :company_id
      
      t.timestamps
    end
  end
end
