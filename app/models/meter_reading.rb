# == Schema Information
#
# Table name: meter_readings
#
#  id                 :integer          not null, primary key
#  irrigation_id      :integer
#  irrigation_well_id :integer
#  company_id         :integer
#  start              :integer
#  stop               :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class MeterReading < ActiveRecord::Base

  belongs_to :irrigation
  belongs_to :irrigation_well

  default_scope { where(company_id: Company.current_id) }

  validates :irrigation_well_id, presence: true,
                                 uniqueness: {scope: :irrigation_id}
  validates :start, numericality: { only_integer: true }
  validates :stop, numericality: { only_integer: true }
end
