require 'spec_helper'

describe GroundFertilizer do

  valid_attributes = { name: "UAN" }
  let(:company) { FactoryGirl.create(:company) }
  let(:fertilizer) { GroundFertilizer.new(valid_attributes) }

  subject { fertilizer }

  before { Company.current_id = company.id }

  it { should be_valid }

  it "has a valid factory" do
    factory = FactoryGirl.build(:ground_fertilizer)
    expect(factory).to be_valid
  end

  describe "tenant security" do

    it "should have only the current company's data" do
      wrong_company = FactoryGirl.create(:company)
      Company.current_id = wrong_company.id
      child = GroundFertilizer.create(valid_attributes)
      expect(child).to be_valid
      Company.current_id = company.id
      fertilizer.save
      expect(GroundFertilizer.all).not_to include(child)
      expect(GroundFertilizer.all).to include(fertilizer)
    end
  end

  describe "attribute" do
    it { should have_db_column :name }
    it { should have_db_column :company_id }
    it { should have_db_column :n }
    it { should have_db_column :p }
    it { should have_db_column :k }
    it { should have_db_column :s }

    context 'mass assigment protection' do
      it { should_not allow_mass_assignment_of :company_id }
      it { should allow_mass_assignment_of :n }
      it { should allow_mass_assignment_of :p }
      it { should allow_mass_assignment_of :k }
      it { should allow_mass_assignment_of :s }
    end

    context 'validation' do
      it { should validate_presence_of :name }
      it { should validate_uniqueness_of :name }
      it { should validate_numericality_of :n }
      it { should validate_numericality_of :p }
      it { should validate_numericality_of :k }
      it { should validate_numericality_of :s }
      it { should validate_presence_of :company_id }

    end
  end
end