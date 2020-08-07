class Shipment < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  has_many :lots, dependent: :restrict_with_error

  validates :name, presence: true,
                   length: { maximum: 20 },
                   uniqueness: { scope: :company_id, case_sensitive: false }
  validates :date, presence: { message: 'must be a date' }
  validates :destination, presence: true,
                          length: { maximum: 50 }
  validates :company_id, presence: true
end
