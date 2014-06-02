class SoilApplication < ActiveRecord::Base

  belongs_to :field
  belongs_to :soil_product

  default_scope { where company_id: Company.current_id }

  validates :soil_product_id, presence: true
  validates :quantity, numericality: true
  validates :date, presence: true

  def formatted_date
   date.to_date.to_s if date
  end
end