# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  name       :string
#  farm_id    :integer
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Block < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :farm#, inverse_of: :blocks
  has_many :fields, -> { order :name }
  accepts_nested_attributes_for :fields

  validates :name,       presence: true,
                         uniqueness: { scope: :farm_id },
                         length: { maximum: 8 }
  validates :company_id, presence: true
  # validates_presence_of :farm
  validates :farm,       presence: true
end
