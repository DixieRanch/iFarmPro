class FreezerLocation < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :farm

  validates :name, presence: true,
                   length: { maximum: 10 },
                   uniqueness: { scope: :farm_id, case_sensitive: false }
  validates :farm_id, presence: true
  validates :company_id, presence: true
end
