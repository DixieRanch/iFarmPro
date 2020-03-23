class Box < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :company
  has_many   :lots, dependent: :restrict_with_error

  validates :name,  presence: true,
                    uniqueness: { scope: :company_id },
                    length: { maximum: 10 }
  validates :empty_weight, numericality: {  allow_nil: true,
                                            greater_than: 150,
                                            less_than: 300 }
  validates :company_id, presence: true

  def empty_weight
    super || 200
  end
end
