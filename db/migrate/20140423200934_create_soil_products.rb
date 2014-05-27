class CreateSoilProducts < ActiveRecord::Migration
  def change
    create_table :soil_products do |t|
      t.integer :company_id
      t.string :name
      t.integer :n
      t.integer :p
      t.integer :k
      t.integer :s

      t.timestamps
    end
  end
end
