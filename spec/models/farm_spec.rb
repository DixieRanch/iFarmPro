# == Schema Information
#
# Table name: farms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#

require 'spec_helper'

describe Farm do

  valid_attributes = FactoryGirl.attributes_for(:farm, weather_station_id: WeatherStation.first.id)

  let(:company) { FactoryGirl.create(Company) }
  # let(:weather_station) { create(:weather_station) }
  let(:farm) { Farm.new(valid_attributes) }
  



  subject { farm }

  before { Company.current_id = company.id }

  it { should be_valid }

  it "should have a valid factory" do
    farm = FactoryGirl.build(:farm)
    expect(farm).to be_valid
  end


  describe "tenant security" do

    it "should have only the current company's data" do
      wrong_company = FactoryGirl.create(:company)
      Company.current_id = wrong_company.id
      child = Farm.create(valid_attributes)
      expect(child).to be_valid
      Company.current_id = company.id
      farm.save
      expect(Farm.all).not_to include(child)
      expect(Farm.all).to include(farm)
    end
  end

  describe "attributes" do
    it { should have_db_column :name }
    it { should have_db_column :company_id }
    it { should have_db_column :weather_station_id }

    context "protected from mass assignment" do
      it { should_not allow_mass_assignment_of :company_id }
      it { should     allow_mass_assignment_of :blocks_attributes }
      it { should allow_mass_assignment_of :irrigation_wells_attributes }
    end
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:company_id) }
    it { should ensure_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:company_id) }
    it { should validate_presence_of(:weather_station_id) }
  end

  describe "associations" do
    it { should accept_nested_attributes_for :blocks }
    it { should accept_nested_attributes_for :irrigation_wells }
    it { should belong_to :weather_station }
 
    it "should return blocks ordered by name" do
      farm.save
      second = farm.blocks.create(name: "Inbetween")
      third = farm.blocks.create(name: "Last")
      first = farm.blocks.create(name: "First")
      correct_order = [first, second, third]
      expect(farm.blocks.to_a).to eq correct_order
    end

    it "should return irrigation_wells ordered by name" do
      farm.save
      second = farm.irrigation_wells.create(name: "Inbetween")
      third = farm.irrigation_wells.create(name: "Last")
      first = farm.irrigation_wells.create(name: "First")
      correct_order = [first, second, third]
      expect(farm.irrigation_wells.to_a).to eq correct_order
    end
  end
end