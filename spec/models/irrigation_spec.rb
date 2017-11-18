# == Schema Information
#
# Table name: irrigations
#
#  id         :integer          not null, primary key
#  time       :datetime
#  field_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  farm_id    :integer
#

require 'rails_helper'
require 'rake'

describe Irrigation do
  valid_attributes = { time: '5/7/2013 19:00' }

  it { expect(Irrigation.new(valid_attributes)).to be_valid }

  it 'has a valid factory' do
    expect(build_stubbed(:irrigation)).to be_valid
  end

  describe 'attribute' do
    it { should have_db_column :time }
    it { should have_db_column :field_id }
    it { should have_db_column :company_id }
    it { should have_db_column :farm_id }
    it { should have_db_index :field_id }
    it { should have_db_index :company_id }
    it { should have_db_index :farm_id }
  end

  describe 'validation' do
    it { should validate_presence_of :time }
  end

  describe 'association' do
    it { should accept_nested_attributes_for :meter_readings }
  end

  describe '#formatted_date' do
    it 'formats date without time' do
      irrigation = build_stubbed :irrigation, time: '5/7/2013 19:00'

      expect(irrigation.formatted_date).to eq 'May 7, 2013'
    end
  end

  describe '#formatted_time' do
    it 'formats time' do
      time = build_stubbed(:irrigation, time: '5/7/2013 19:00').formatted_time

      expect(time).to eq 'May 7, 2013 19:00'
    end
  end

  describe '::next_irrigations' do
    it { expect(Irrigation.next_irrigations).to be_kind_of(Array) }

    it 'has Irrigation elements' do
      set_tenant_company
      create :irrigation

      expect(Irrigation.next_irrigations.first).to be_kind_of(Irrigation)
    end
  end

  describe '#next_irrigation_date' do
    it 'should return a the next irrigation date' do
      irrigation = build_stubbed :irrigation

      expect(irrigation.next_irrigation_date).to be_kind_of(Date)
      expect(irrigation.next_irrigation_date).to be > irrigation.time.to_date
    end

    it 'should properly handle irrigation interval that crosses new year' do
      irrigation = build_stubbed :irrigation, time: 'Dec 30, 2012 12:00'

      expect(irrigation.next_irrigation_date.year).to be 2013
    end

    context 'after rain' do
      it 'has later date' do
        irrigation = build_stubbed(:irrigation)
        farm = irrigation.field.block.farm
        pre_rain_irrigation_date = irrigation.next_irrigation_date

        create(:rain, date: pre_rain_irrigation_date - 1, farm: farm)
        post_rain_irrigation_date = irrigation.next_irrigation_date

        expect(post_rain_irrigation_date).to be > pre_rain_irrigation_date
      end

      it 'same date if available water is at maximum' do
        irrigation = build_stubbed :irrigation
        create(:rain, date:   irrigation.time.to_date + 2,
                      amount: 10.0,
                      farm:   irrigation.field.block.farm)
        current_date = irrigation.next_irrigation_date
        create(:rain, date:   irrigation.time.to_date + 1,
                      amount: 10.0,
                      farm:   irrigation.field.block.farm)

        future_date = irrigation.next_irrigation_date

        expect(future_date).to eq current_date
      end
    end
  end
end
