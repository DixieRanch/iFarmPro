# == Schema Information
#
# Table name: farms
#
#  id                 :integer          not null, primary key
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  company_id         :integer
#  weather_station_id :integer
#

class Farm < ActiveRecord::Base

  default_scope { where(company_id: Company.current_id) }

  has_many :blocks,  -> { order :name }, { inverse_of: :farm }
  has_many :irrigation_wells, -> { order :name }
  has_many :rains
  belongs_to :weather_station
  accepts_nested_attributes_for :blocks
  accepts_nested_attributes_for :irrigation_wells

  validates :name, presence: true,
                    uniqueness: { scope: :company_id },
                    length: { maximum: 50 }
  validates :company_id, presence: true
  validates :weather_station, presence: true
end
