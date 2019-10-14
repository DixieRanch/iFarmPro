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
  valid_attributes = { name: 'a' }

  it 'is valid' do
    set_tenant_company

    expect(build_stubbed(:farm).blocks.new(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    set_tenant_company

    expect(build_stubbed(:block)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :farm }
    it { should validate_presence_of :company_id }
    it { should validate_length_of(:name).is_at_most 8 }
    it 'has a unique case insensitive name scoped to farm' do
      block = build_stubbed(:farm).blocks.new(valid_attributes)

      expect(block).to validate_uniqueness_of(:name).case_insensitive
                                                    .scoped_to :farm_id
    end
  end

  describe 'association' do
    it { should accept_nested_attributes_for :fields }

    it 'should return fields ordered by name' do
      set_tenant_company
      block = create :block
      second = block.fields.create(name: 'Inbtween', soil_class_id: 1)
      third  = block.fields.create(name: 'Last', soil_class_id: 1)
      first  = block.fields.create(name: 'First', soil_class_id: 1)

      expect(block.fields.to_a).to eq [first, second, third]
    end
  end
end
