class ChangeDateTypeInSoilApplications < ActiveRecord::Migration
  def up
    change_column :soil_applications, :date, :date
  end

  def down
    change_column :soil_applications, :date, :datetime
  end
end