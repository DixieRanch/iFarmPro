class FreezerLocation < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }
  scope :by_name_numerically, (
  lambda do
    order("COALESCE(SUBSTRING(name FROM '^(\\d+)')::INTEGER),
           SUBSTRING(name FROM '^\\d*(.*?)(\\d+)?$'),
           COALESCE(SUBSTRING(name FROM '(\\d+)$')::INTEGER),
           name")
  end
  )

  belongs_to :farm
  has_many   :lots, dependent: :restrict_with_error

  validates :name, presence: true,
                   length: { maximum: 10 },
                   uniqueness: { scope: :farm_id, case_sensitive: false }
  validates :farm_id, presence: true
  validates :company_id, presence: true

  def location_weight
    Lot.where(freezer_location_id: id).map(&:net_weight).sum
  end

  def lot_count
    Lot.where(freezer_location_id: id).count
  end
end
