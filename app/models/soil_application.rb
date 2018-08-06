# == Schema Information
#
# Table name: soil_applications
#
#  id                       :integer          not null, primary key
#  field_id                 :integer
#  soil_product_id          :integer
#  quantity                 :float
#  company_id               :integer
#  created_at               :datetime
#  updated_at               :datetime
#  date                     :date
#  soil_application_unit_id :integer
#

class SoilApplication < ActiveRecord::Base
  attr_accessor :next_application

  belongs_to :field
  belongs_to :soil_product
  belongs_to :soil_application_unit

  default_scope { where company_id: Company.current_id }
  scope :herbicide, lambda {
    ids = SoilProduct.where('lower(name) like ?', '%prowl%').ids
    SoilApplication.where(soil_product_id: ids)
  }

  validates :soil_product_id, presence: true
  validates :quantity, numericality: true
  validates :date, presence: { message: 'must be a date' }
  validates :soil_application_unit_id, presence: true

  def formatted_date
    date.strftime('%B %-d, %Y') if date
  end

  def date=(value)
    self[:date] = Date.parse(value)
  rescue TypeError, ArgumentError
    self[:date] = value
  end

  def self.next_applications
    current_applications.each do |application|
      application.next_application = application.next_application_date
    end
  end

  def next_application_date
    app_date = date + 60.days
    irr = field.irrigations.last
    irr_date = irr.next_irrigation_date - 2.days
    [app_date, irr_date].max
  end

  private_class_method def self.current_applications
    Field.includes(:soil_applications).map do |field|
      last_application(field) || default_application(field)
    end
  end

  private_class_method def self.last_application(field)
    field.soil_applications.herbicide.order('date').last
  end

  private_class_method def self.default_application(field)
    field.soil_applications.new(
      date: Time.zone.local(Time.zone.now.year) - 184.days
    )
  end
end
