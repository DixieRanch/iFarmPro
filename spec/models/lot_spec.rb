require 'rails_helper'
describe Lot do
  valid_attributes = { name: '2018-001',
                       full_weight: 2000,
                       box_id: 1,
                       freezer_location_id: 1,
                       block_id: 1 }

  it 'is valid' do
    set_tenant_company

    expect(Lot.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    expect(build_stubbed(:lot)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :full_weight }
    it { should have_db_column :company_id }
    it { should have_db_column :box_id }
    it { should have_db_column :freezer_location_id }
    it { should have_db_column :block_id }
    it { should have_db_column :field_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most 8 }
    it { should validate_numericality_of(:full_weight).is_greater_than(150) }
    it { should validate_presence_of :company_id }
    it { should validate_presence_of :box_id }
    it { should validate_presence_of :freezer_location_id }
    it { should validate_presence_of :block_id }
  end

  describe 'association' do
    it { should belong_to :box }
    it { should belong_to :freezer_location }
  end
end
