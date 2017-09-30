# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  name       :string
#  farm_id    :integer
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Block do
  valid_attributes = { name: "1" }
  let(:company) { build_stubbed(:company) }
  let(:farm) { build_stubbed(:farm) }
  let(:block) { farm.blocks.new(valid_attributes) }

  before do
    Company.current_id = company.id
  end

  subject { block }

  it { should be_valid }

  it "should have a valid factory" do
    factory = FactoryGirl.build(:block)
    expect(factory).to be_valid
  end

  describe "tenant security" do
    
    it "should have only the current company's data" do
      wrong_company = FactoryGirl.build_stubbed(:company)
      Company.current_id = wrong_company.id
      parent = FactoryGirl.build_stubbed(:farm)
      expect(parent).to be_valid
      child = parent.blocks.create(valid_attributes)
      expect(child).to be_valid
      Company.current_id = company.id
      block.save
      expect(Block.all).not_to include(child)
      expect(Block.all).to include(block)
    end
  end

  describe "unvalidated attributes" do
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :farm }
    it { should validate_presence_of :company_id }
    it { 
      should validate_uniqueness_of(:name).case_insensitive
                                              .scoped_to :farm_id 
    }
    it { should validate_length_of(:name).is_at_most 8 }
  end

  describe "association" do
    it { should accept_nested_attributes_for :fields }

    it "should return fields ordered by name" do
      block.save
      second = block.fields.create(name: "Inbtween", soil_class_id: 1)
      third = block.fields.create(name: "Last", soil_class_id: 1)
      first = block.fields.create(name: "First", soil_class_id: 1)
      correct_order = [first, second, third]
      expect(block.fields.to_a).to eq correct_order
    end
  end
end
