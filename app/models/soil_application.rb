# == Schema Information
#
# Table name: soil_applications
#
#  id                       :integer          not null, primary key
#  field_id                 :integer
#  soil_product_id          :integer
#  quantity                 :float
#  company_id               :integer
#  created_at               :datetime
#  updated_at               :datetime
#  date                     :date
#  soil_application_unit_id :integer
#

class SoilApplication < ActiveRecord::Base
  belongs_to :field
  belongs_to :soil_product
  belongs_to :soil_application_unit

  default_scope { where company_id: Company.current_id }

  validates :soil_product_id, presence: true
  validates :quantity, numericality: true
  validates :date, presence: { message: 'must be a date' }
  validates :soil_application_unit_id, presence: true

  def formatted_date
    date.strftime('%B %-d, %Y') if date
  end

  def date=(value)
    self[:date] = Date.parse(value)
  rescue TypeError, ArgumentError
    self[:date] = value
  end
end
