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

  def move_all_lots_to(new_location)
    lots.each do |lot|
      lot.move_to(new_location)
    end
  end
end
