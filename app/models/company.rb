# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  cattr_accessor :current_id

  has_many :users
  has_many :farms

  accepts_nested_attributes_for :users

  validates :name, presence: true,
                   length: { maximum: 50 }
end