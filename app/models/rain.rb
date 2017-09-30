# == Schema Information
#
# Table name: rains
#
#  id         :integer          not null, primary key
#  date       :date
#  amount     :decimal(, )
#  farm_id    :integer
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Rain < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :farm

  validates :date, presence: {message: 'must be a date'},
                   uniqueness: { scope: :farm_id }
  validates :amount, presence: true,
                     numericality: true
  validates :farm_id, presence: true

  def formatted_date
    date.to_s(:long).squeeze(" ") if date
  end

  def date=(value)
    self[:date] = Date.parse(value)
  rescue ArgumentError, TypeError
    self[:date] = value
  end

  private
end
