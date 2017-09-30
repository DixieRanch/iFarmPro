class AddSoilApplicationUnitIdToSoilApplications < ActiveRecord::Migration
  def change
    add_column :soil_applications, :soil_application_unit_id, :integer
  end
end
