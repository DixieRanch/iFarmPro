# == Schema Information
#
# Table name: fields
#
#  id            :integer          not null, primary key
#  name          :string
#  acreage       :decimal(, )
#  block_id      :integer
#  company_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  farm_id       :integer
#  soil_class_id :integer
#

class Field < ActiveRecord::Base
  # attr_accessor :current_n

  belongs_to :block
  belongs_to :soil_class
  has_many :irrigations, -> { order :time }, dependent: :restrict_with_error
  has_many :soil_applications, dependent: :restrict_with_error

  default_scope { where(company_id: Company.current_id) }

  validates :name, presence: true,
                   uniqueness: { scope: :block_id },
                   length: { maximum: 8 }
  validates :acreage, numericality: true, allow_nil: true
  validates :company_id, presence: true
  validates :soil_class_id, presence: true

  def name_with_block
    block.name + '-' + name
  end

  def get_yearly_amount_of(nutrient, year)
    total_nutrient = 0
    current_apps = soil_applications.where('extract(year from date) = ?', year)
    current_apps.each do |soil_app|
      nutrient_units = soil_app.soil_product.send(nutrient).to_f
      units = nutrient_units * soil_app.quantity / 100
      density = soil_app.soil_application_unit.density
      total_nutrient += units * density / acreage
    end
    total_nutrient.to_f
  end
end
