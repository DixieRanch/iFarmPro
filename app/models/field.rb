# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  acreage    :decimal(, )
#  block_id   :integer
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farm_id    :integer
#

class Field < ActiveRecord::Base
  attr_accessible :acreage, :name, :soil_class_id

  belongs_to :block
  belongs_to :soil_class
  has_many :irrigations, order: 'time'
  has_many :soil_applications

  default_scope { where(company_id: Company.current_id) }

  validates :name, presence: true,
                   uniqueness: { scope: :block_id },
                   length: { maximum: 10 }
  validates :acreage, numericality: true, allow_nil: true
  validates :company_id, presence: true
  validates :soil_class_id, presence: true

  def name_with_block
    block.name + "-" + name
  end
end