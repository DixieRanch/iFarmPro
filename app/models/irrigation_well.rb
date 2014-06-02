class IrrigationWell < ActiveRecord::Base

  belongs_to :farm

  default_scope { where(company_id: Company.current_id) }

  validates :name,  presence: true,
                    uniqueness: { scope: :farm_id }
  validates :company_id, presence: true
end