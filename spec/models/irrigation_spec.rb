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

  describe '::last' do
    context 'when field has multiple irrigations' do
      it 'returns irrigation with the most recent date' do
        set_tenant_company
        field = create :field
        last_irrigation = create(:irrigation, time: 1.month.ago, field: field)
        create(:irrigation, time: 3.months.ago, field: field)

        expect(Irrigation.last_for(field)).to eq last_irrigation
      end
    end

    context 'when field has no irrigations' do
      it 'returns irrigation with date July 1st, previous year' do
        set_tenant_company
        field = create :field

        expect(Irrigation.last_for(field).time).to eq(
          Time.zone.local((Time.zone.now.year - 1), 7, 1)
        )
      end
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
end
