# == Schema Information
#
# Table name: meter_readings
#
#  id                 :integer          not null, primary key
#  irrigation_id      :integer
#  irrigation_well_id :integer
#  company_id         :integer
#  start              :integer
#  stop               :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'rails_helper'

describe MeterReading do
  let(:company) { build_stubbed(:company) }
  let(:irrigation) { build_stubbed(:irrigation) }
  let(:well) { build_stubbed(:irrigation_well) }

  let(:meter_reading) { irrigation.meter_readings.build(@valid_attributes) }

  before do
    Company.current_id = company.id
    @valid_attributes = { start: 112233,
                          stop: 223344,
                          irrigation_well_id: well.id }
  end

  subject { meter_reading }

  it { should be_valid }

  it 'should have a valid factory' do
    factory = FactoryGirl.build(:meter_reading)
    expect(factory).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :start }
    it { should have_db_column :stop }
    it { should have_db_column :irrigation_id }
    it { should have_db_column :irrigation_well_id }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :irrigation_well_id }
    it { should validate_numericality_of(:start).only_integer }
    it { should validate_numericality_of(:stop).only_integer }
    it {
      should validate_uniqueness_of(:irrigation_well_id)
        .scoped_to(:irrigation_id)
    }
  end
end
