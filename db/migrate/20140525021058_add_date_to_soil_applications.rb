class AddDateToSoilApplications < ActiveRecord::Migration
  def change
    add_column :soil_applications, :date, :date
  end
end
