class GroundFertilizer < ActiveRecord::Base
  attr_accessible :name, :n, :p, :k, :s

  default_scope { where(company_id: Company.current_id) }

  validates :company_id, presence: true
  validates :name, presence: true,
                   uniqueness: { scope: :company_id }
  validates :n, numericality: true,
                allow_nil: true
  validates :p, numericality: true,
                allow_nil: true
  validates :k, numericality: true,
                allow_nil: true
  validates :s, numericality: true,
                allow_nil: true
end
