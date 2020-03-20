# == Schema Information
#
# Table name: irrigations
#
#  id         :integer          not null, primary key
#  time       :datetime
#  field_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  farm_id    :integer
#

class Irrigation < ActiveRecord::Base
  attr_accessor :next_irrigation

  belongs_to :field
  has_many :meter_readings, dependent: :restrict_with_error
  accepts_nested_attributes_for :meter_readings

  default_scope { where(company_id: Company.current_id) }

  validates :time, presence: true

  def formatted_date
    time.strftime('%B %-d, %Y') if time
  end

  def formatted_time
    time.strftime('%B %-d, %Y %R') if time
  end

  def self.last_for(field)
    field.irrigations.order('time').last || NullIrrigation.new(field)
  end

  def self.next_irrigations
    current_irrigations.each do |irrigation|
      field = irrigation.field
      irrigation.next_irrigation = NextIrrigation.call(irrigation, field)
    end
  end

  private_class_method def self.current_irrigations
    Field.includes(:irrigations).map do |field|
      last_for(field)
    end
  end
end
