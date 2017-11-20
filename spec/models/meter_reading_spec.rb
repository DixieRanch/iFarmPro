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
  valid_attributes = { start: 112233,
                       stop: 223344,
                       irrigation_well_id: 1 }

  it 'is valid wtih valid_attributes' do
    irrigation = build_stubbed :irrigation
    expect(irrigation.meter_readings.new(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    expect(build_stubbed(:meter_reading)).to be_valid
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
