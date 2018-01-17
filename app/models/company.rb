# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Company < ActiveRecord::Base
  cattr_accessor :current_id

  has_many :users, dependent: :restrict_with_error
  has_many :farms, dependent: :restrict_with_error
  has_many :user_invitations, dependent: :destroy

  accepts_nested_attributes_for :users

  validates :name, presence: true,
                   length: { maximum: 50 }
end
