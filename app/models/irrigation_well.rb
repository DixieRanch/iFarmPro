# == Schema Information
#
# Table name: irrigation_wells
#
#  id         :integer          not null, primary key
#  name       :string
#  pod_code   :string
#  farm_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

class IrrigationWell < ActiveRecord::Base
  belongs_to :farm

  default_scope { where(company_id: Company.current_id) }

  validates :name,  presence: true,
                    uniqueness: { scope: :farm_id }
  validates :company_id, presence: true
end
