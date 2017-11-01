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
  let(:company) { build_stubbed(:company) }
  let(:field) { build_stubbed(:field) }
  let(:product) { build_stubbed(:soil_product) }
  let(:application) { field.soil_applications.build(@valid_attributes) }

  subject { application }

  before do
    Company.current_id = company.id
    @valid_attributes = { quantity: 150, soil_product_id: product.id,
                          date: '01/01/2014', soil_application_unit_id: 1 }
  end

  it { should be_valid }

  it 'has a valid factory' do
    factory = build(:soil_application)
    expect(factory).to be_valid
  end

  describe 'security' do
    it "has only the current company's data" do
      application.save
      wrong_company = create(:company)
      Company.current_id = wrong_company.id
      wrong_data = create(:soil_application)
      expect(wrong_data).to be_valid
      expect(SoilApplication.all).not_to include(application)
      expect(SoilApplication.all).to include(wrong_data)
    end
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
        application.date = ''
        expect(application.formatted_date).to eq nil
      end

      it 'returns date formatted as date' do
        application.date = '1/8'
        year = Time.zone.now.year
        expect(application.formatted_date).to eq "January 8, #{year}"
      end
    end
  end
end
