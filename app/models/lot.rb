class Lot < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :box
  belongs_to :freezer_location
  belongs_to :block
  belongs_to :field

  validates :name, presence: true,
                   uniqueness: { scope: :company_id },
                   length: { maximum: 8 }
  validates :full_weight, numericality: { greater_than: 150 }
  validates :company_id, presence: true
  validates :box_id, presence: true
  validates :freezer_location_id, presence: true
  validates :block_id, presence: true

  def net_weight
    full_weight - box.empty_weight
  end
end
