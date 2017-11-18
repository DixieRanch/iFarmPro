# == Schema Information
#
# Table name: irrigation_wells
#
#  id         :integer          not null, primary key
#  name       :string
#  pod_code   :string
#  farm_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

require 'rails_helper'

describe IrrigationWell do
  valid_attributes = { name: 'Pump 1', pod_code: 'lrg-12345-pod1' }

  it 'is valid ' do
    set_tenant_company
    farm = build_stubbed :farm

    expect(farm.irrigation_wells.build(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    set_tenant_company

    expect(build_stubbed(:irrigation_well)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :pod_code }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to :farm_id }
    it { should validate_presence_of :company_id }
  end
end
