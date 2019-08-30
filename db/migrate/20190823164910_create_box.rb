class CreateBox < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :name
      t.integer :empty_weight
      t.integer :company_id
      
      t.timestamps
    end
  end
end
