# == Schema Information
#
# Table name: soil_application_units
#
#  id         :integer          not null, primary key
#  name       :string
#  density    :float
#  created_at :datetime
#  updated_at :datetime
#

class SoilApplicationUnit < ActiveRecord::Base
  # has_many :soil_applications
  
  validates :name,    presence: true, uniqueness: { case_sensitive: false }
  validates :density, presence: true, numericality: true
end
