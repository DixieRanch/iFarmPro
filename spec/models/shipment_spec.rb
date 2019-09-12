require 'rails_helper'

describe Shipment do
  valid_attributes = {name: '2018-001',
                      date: '1/1/2018',
                      destination: 'Sheller'}

  it 'is valid' do
    set_tenant_company

    expect(Shipment.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    expect(build_stubbed(:shipment)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :date }
    it { should have_db_column :destination }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most 20 }
    it { should validate_uniqueness_of(:name).case_insensitive
                                             .scoped_to :company_id }
    it { should validate_presence_of(:date).with_message(/must be a date/) }
    it { should validate_presence_of :destination }
    it { should validate_length_of(:destination).is_at_most 50 }
    it { should validate_presence_of :company_id }
  end
end
