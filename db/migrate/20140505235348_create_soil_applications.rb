class CreateSoilApplications < ActiveRecord::Migration
  def change
    create_table :soil_applications do |t|
      t.integer :field_id
      t.integer :soil_product_id
      t.float :quantity
      t.integer :company_id
      
      t.timestamps
    end
    add_index :soil_applications, :field_id
    add_index :soil_applications, :soil_product_id
    add_index :soil_applications, :company_id
  end
end
