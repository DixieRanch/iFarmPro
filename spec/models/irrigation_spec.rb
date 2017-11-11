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
# require 'csv'

describe Irrigation do
  valid_attributes = { time: '5/7/2013 19:00' }
  let(:company)    { build_stubbed(:company) }
  let(:field)      { create(:field) }
  let(:irrigation) { field.irrigations.new(valid_attributes) }

  before { Company.current_id = company.id }

  subject { irrigation }

  it { should be_valid }

  it 'should have a valid factory' do
    factory = FactoryGirl.build(:irrigation)
    expect(factory).to be_valid
  end

  describe 'security' do
    it "should have only the current company's data" do
      irrigation.save
      wrong_company = FactoryGirl.build_stubbed(:company)
      Company.current_id = wrong_company.id
      wrong_data = FactoryGirl.create(:irrigation)
      expect(wrong_data).to be_valid
      expect(Irrigation.all).to include(wrong_data)
      expect(Irrigation.all).not_to include(irrigation)
      Company.current_id = company.id
      expect(Irrigation.all).not_to include(wrong_data)
      expect(Irrigation.all).to include(irrigation)
    end
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

  describe 'self.formatted_date' do
    it 'formats date without time' do
      date = irrigation.formatted_date
      expect(date).to eq 'May 7, 2013'
    end
  end

  describe 'self.formatted_time' do
    it 'formats time' do
      time = irrigation.formatted_time
      expect(time).to eq 'May 7, 2013 19:00'
    end
  end

  describe 'self.next_irrigations' do
    let(:next_irrigations) { Irrigation.next_irrigations }
    before { irrigation.save }

    specify { expect(next_irrigations).to be_kind_of(Array) }
    specify { expect(next_irrigations.first).to be_kind_of(Irrigation) }
  end

  describe '.next_irrigation_date' do
    let(:next_irrigation) do
      irrigation.next_irrigation_date
    end

    it 'should return a the next irrigation date' do
      expect(next_irrigation).to be_kind_of(Date)
      expect(next_irrigation).to be > irrigation.time.to_date
    end

    it 'should properly handle irrigation interval that crosses new year' do
      irrigation.time = 'Dec 30, 2012 12:00'
      irrigation.save
      expect(next_irrigation.year).to be 2013
    end

    context 'after rain' do
      let(:args) {}
      let(:farm) { irrigation.field.block.farm }

      it 'has later date' do
        current_date = next_irrigation
        FactoryGirl.create(:rain, date: next_irrigation - 1, farm: farm)
        future_date = irrigation.next_irrigation_date(*args)
        expect(current_date).to be < future_date
      end

      it 'same date if available water is at maximum' do
        FactoryGirl.create(:rain, date:   irrigation.time.to_date + 2,
                                  amount: 10.0,
                                  farm:   farm)
        current_date = irrigation.next_irrigation_date(*args)
        FactoryGirl.create(:rain, date:   irrigation.time.to_date + 1,
                                  amount: 10.0,
                                  farm:   farm)
        future_date = irrigation.next_irrigation_date(*args)
        expect(current_date).to eq future_date
      end
    end
  end
end
