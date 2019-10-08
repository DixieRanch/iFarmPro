class Lot < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  validates :name, presence: true,
                   length: { maximum: 8 }
  validates :full_weight, numericality: { greater_than: 150 }
  validates :company_id, presence: true
  validates :box_id, presence: true
  validates :freezer_location_id, presence: true
  validates :block_id, presence: true
  validates :field_id, numericality: { only_integer: true, allow_nil: true }
end
