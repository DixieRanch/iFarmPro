# == Schema Information
#
# Table name: kcs
#
#  id         :integer          not null, primary key
#  doy        :integer
#  pecan      :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class Kc < ActiveRecord::Base
  # attr_accessible :doy, :pecan
end
