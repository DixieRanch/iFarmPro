require 'spec_helper'

describe SoilApplication do
  let(:company) { create(:company) }
  let(:field) { create(:field) }
  let(:product) { create(:soil_product) }
  let(:application) { field.soil_applications.build(@valid_attributes) }


  subject { application }

  before do
    Company.current_id = company.id
    @valid_attributes = { quantity: 150, soil_product_id: product.id }
  end

  it { should be_valid }

  it "has a valid factory" do
    factory = build(:soil_application)
    expect(factory).to be_valid
  end

  context 'security' do
    
    it "has only the current company's data" do
      application.save
      wrong_company = create(:company)
      Company.current_id = wrong_company.id
      wrong_data = create(:soil_application)
      expect(wrong_data).to be_valid
      expect(SoilApplication.all).not_to include(application)
      expect(SoilApplication.all).to include(wrong_data)
    end

    it { should_not allow_mass_assignment_of :company_id }
    it { should_not allow_mass_assignment_of :field_id }
  end

  context 'attributes' do
    it { should have_db_column :company_id }
    it { should have_db_column :field_id }
    it { should have_db_column :soil_product_id }
    it { should have_db_column :quantity }
  end

  context 'validations' do
    it { should validate_presence_of :soil_product_id }
    it { should validate_numericality_of :quantity }
  end
end