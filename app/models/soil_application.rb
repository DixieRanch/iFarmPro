class SoilApplication < ActiveRecord::Base
  attr_accessible :quantity, :soil_product_id

  belongs_to :field
  belongs_to :soil_product

  default_scope { where company_id: Company.current_id }

  validates :soil_product_id, presence: true
  validates :quantity, numericality: true
end
