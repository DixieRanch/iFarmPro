require 'rails_helper'

describe IrrigationWell do

  valid_attributes = { name: 'Pump 1', pod_code: 'lrg-12345-pod1' }
  let(:company) { build_stubbed(:company) }
  let(:farm) { build_stubbed(:farm) }
  let(:well) { farm.irrigation_wells.build(valid_attributes) }

  before do
    Company.current_id = company.id
  end

  subject { well }

  it { should be_valid }

  it "should have a valid factory" do
    factory = FactoryGirl.build(:irrigation_well)
    expect(factory).to be_valid
  end

  describe "tenant security" do
    it "should have only the current company's data" do
      well.save
      wrong_company = FactoryGirl.create(:company)
      Company.current_id = wrong_company.id
      wrong_data = FactoryGirl.create(:irrigation_well)
      expect(wrong_data).to be_valid
      Company.current_id = company.id
      expect(IrrigationWell.all).not_to include(wrong_data)
      expect(IrrigationWell.all).to include(well)
    end
  end

  describe "attributes" do
    it { should have_db_column :name }
    it { should have_db_column :pod_code }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to :farm_id }
    it { should validate_presence_of :company_id }
  end
end