class Rain < ActiveRecord::Base

  default_scope { where(company_id: Company.current_id) }

  belongs_to :farm

  validates :date, presence: true,
                    uniqueness: { scope: :farm_id }
  validates :amount, presence: true,
                      numericality: true
  validates :farm_id, presence: true

  def formatted_date
    date.to_s(:long).squeeze(" ") if date
  end

end