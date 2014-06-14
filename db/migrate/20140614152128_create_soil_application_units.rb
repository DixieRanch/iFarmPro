class CreateSoilApplicationUnits < ActiveRecord::Migration
  def change
    create_table :soil_application_units do |t|
      t.string :name
      t.float :density

      t.timestamps
    end
  end
end
