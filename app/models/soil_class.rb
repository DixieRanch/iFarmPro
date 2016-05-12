# == Schema Information
#
# Table name: soil_classes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  aw         :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class SoilClass < ActiveRecord::Base

  has_many :fields
end
