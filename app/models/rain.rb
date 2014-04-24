class Rain < ActiveRecord::Base
  attr_accessible :amount, :date

  default_scope { where(company_id: Company.current_id) }

  belongs_to :farm

  validates :date, presence: true,
                    uniqueness: { scope: :farm_id }
  validates :amount, presence: true,
                      numericality: true
  validates :farm_id, presence: true

  def formatted_date
    date.strftime('%m/%d/%Y') unless date.blank?
  end

end