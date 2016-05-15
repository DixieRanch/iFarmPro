class CreateAverageEts < ActiveRecord::Migration
  def change
    create_table :average_ets do |t|
      t.integer :doy
      t.float :eth
      t.references :weather_station, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :average_ets, :doy
  end
end
