class AddWebsiteIdToWeatherStations < ActiveRecord::Migration
  def change
    add_column :weather_stations, :website_id, :integer
    add_index :weather_stations, :website_id
  end
end
