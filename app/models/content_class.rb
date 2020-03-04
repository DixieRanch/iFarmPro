class ContentClass < ActiveRecord::Base
  has_many :lots, dependent: :restrict_with_error

  validates :grade, presence: true
end
