class CreateDailyEts < ActiveRecord::Migration
  def change
    create_table :daily_ets do |t|
      t.date :date
      t.float :eth
      t.references :weather_station, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :daily_ets, :date
  end
end
