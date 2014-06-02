require 'spec_helper'

describe MeterReading do
  let(:company) { FactoryGirl.create(:company) }
  let(:irrigation) { FactoryGirl.create(:irrigation) }
  let(:well) { FactoryGirl.create(:irrigation_well) }
  
  let(:meter_reading) { irrigation.meter_readings.build(@valid_attributes) }

  before do
    Company.current_id = company.id
    @valid_attributes = { start: 112233, 
                       stop: 223344,
                       irrigation_well_id: well.id }
  end

  subject { meter_reading }

  it { should be_valid }

  it "should have a valid factory" do
    factory = FactoryGirl.build(:meter_reading)
    expect(factory).to be_valid
  end

  describe "security" do
    
    it "should have only the current company's data" do
      meter_reading.save
      wrong_company = FactoryGirl.create(:company)
      Company.current_id = wrong_company.id
      wrong_data = FactoryGirl.create(:meter_reading)
      expect(wrong_data).to be_valid
      Company.current_id = company.id
      expect(MeterReading.all).not_to include(wrong_data)
      expect(MeterReading.all).to include(meter_reading)
    end
  end

  describe "attributes" do
    it { should have_db_column :start }
    it { should have_db_column :stop }
    it { should have_db_column :irrigation_id }
    it { should have_db_column :irrigation_well_id }
    it { should have_db_column :company_id }
  end

  describe "validations" do
    it { should validate_presence_of :irrigation_well_id }
    it { should validate_numericality_of(:start).only_integer }
    it { should validate_numericality_of(:stop).only_integer }
    it { should validate_uniqueness_of(:irrigation_well_id)
                            .scoped_to(:irrigation_id) }
  end
end