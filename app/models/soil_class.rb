# == Schema Information
#
# Table name: soil_classes
#
#  id         :integer          not null, primary key
#  name       :string
#  aw         :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class SoilClass < ActiveRecord::Base
  has_many :fields
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :aw,   presence: true, numericality: true
end
