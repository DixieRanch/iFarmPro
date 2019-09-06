class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :name
      t.datetime :date
      t.string :destination
      t.integer :farm_id
      t.integer :company_id
      
      t.timestamps
    end
  end
end
