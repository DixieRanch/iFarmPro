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

      it 'has SoilApplication elements' do
        set_tenant_company
        product = create(:soil_product, name: 'Roundup')
        application = create(:soil_application, soil_product: product)
        create(:irrigation, field: application.field)

        expect(SoilApplication.next_applications.first)
          .to be_kind_of(SoilApplication)
      end

      it 'only has elements that are Prowl, or Pindar applications' do
        set_tenant_company
        prowl = create(:soil_product, name: 'Prowl')
        prowl_application = create(:soil_application, soil_product: prowl)
        fertilizer_application = create(:soil_application)
        create(:irrigation, field: prowl_application.field)
        create(:irrigation, field: fertilizer_application.field)

        expect(SoilApplication.next_applications)
          .not_to include(fertilizer_application)
        expect(SoilApplication.next_applications)
          .to include(prowl_application)
      end

      it 'has a SoilApplication element when given nil input' do
        set_tenant_company
        field = create :field
        create(:irrigation, field: field)

        expect(SoilApplication.next_applications.first)
          .to be_kind_of(SoilApplication)
      end
    end

    describe '#next_application_date' do
      it 'should return a date' do
        set_tenant_company
        application = create(:soil_application)
        create(:irrigation, field: application.field)

        expect(application.next_application_date).to be_kind_of(Date)
      end

      context 'when next irrigation is 62 days away or less' do
        it 'should return 60 days since last application' do
          set_tenant_company
          application = create(:soil_application)
          create(:irrigation, field: application.field, time: 1.year.ago)

          expect(application.next_application_date)
            .to eq application.date + 60.days
        end
      end

      context 'when next irrigation is more than 62 days after application' do
        it 'should return 2 days before irrigation' do
          set_tenant_company
          application = create(:soil_application)
          irrigation = create(:irrigation, field: application.field,
                                           time: application.date + 60.days)

          expect(application.next_application_date)
            .to eq irrigation.next_irrigation_date - 2.days
        end
      end
    end
  end
end
