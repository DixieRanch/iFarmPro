class Content < ActiveRecord::Base
  has_many :lots, dependent: :restrict_with_error

  validates :name, presence: true
end
