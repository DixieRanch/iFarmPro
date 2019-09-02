require 'rails_helper'

describe FreezerLocation do
  valid_attributes = { name: 'Freezer' }

  it 'is valid' do
    set_tenant_company

    expect(build_stubbed(:farm).blocks.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    expect(build_stubbed(:freezer_location)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :farm_id }
    it { should validate_presence_of :company_id }
  end
end
