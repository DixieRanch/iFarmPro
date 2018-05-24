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

require 'rails_helper'

describe SoilApplication do
  valid_attributes = { quantity: 150,
                       date: '01/01/2014',
                       soil_product_id: 1,
                       soil_application_unit_id: 1 }

  it 'is valid' do
    field = build_stubbed(:field)

    expect(field.soil_applications.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    expect(build_stubbed(:soil_application)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :company_id }
    it { should have_db_column :field_id }
    it { should have_db_column :soil_product_id }
    it { should have_db_column :quantity }
    it { should have_db_column :date }
    it { should have_db_column :soil_application_unit_id }
  end

  describe 'validations' do
    it { should validate_presence_of :soil_product_id }
    it { should validate_numericality_of :quantity }
    it { should validate_presence_of(:date).with_message(/must be a date/) }
    it { should validate_presence_of :soil_application_unit_id }
  end

  describe 'method' do
    describe 'formatted_date' do
      it 'reutrns nil when nil' do
        soil_application = SoilApplication.new

        expect(soil_application.formatted_date).to eq nil
      end

      it 'returns date formatted as date' do
        soil_application = SoilApplication.new(date: '1/8/2017')

        expect(soil_application.formatted_date).to eq 'January 8, 2017'
      end
    end
    
    describe '::next_applications' do
      it { expect(SoilApplication.next_applications).to be_kind_of(Array) }
    end
  end
end
