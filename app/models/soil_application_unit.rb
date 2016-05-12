# == Schema Information
#
# Table name: soil_application_units
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  density    :float
#  created_at :datetime
#  updated_at :datetime
#

class SoilApplicationUnit < ActiveRecord::Base
  # has_many :soil_applications
end
