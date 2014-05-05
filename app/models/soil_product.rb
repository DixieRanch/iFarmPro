class SoilProduct < ActiveRecord::Base
  attr_accessible :name, :n, :p, :k, :s

  default_scope { where(company_id: Company.current_id) }

  validates :company_id, presence: true
  validates :name, presence: true,
                   uniqueness: { scope: :company_id }
  validates :n, numericality: { only_integer: true },
                allow_nil: true
  validates :p, numericality: { only_integer: true },
                allow_nil: true
  validates :k, numericality: { only_integer: true },
                allow_nil: true
  validates :s, numericality: { only_integer: true },
                allow_nil: true
end
