# == Schema Information
#
# Table name: rains
#
#  id         :integer          not null, primary key
#  date       :date
#  amount     :decimal(, )
#  farm_id    :integer
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Rain do
  valid_attributes = { date: '5/1/2013', amount: 0.35 }

  it 'is valid' do
    set_tenant_company

    expect(build_stubbed(:farm).rains.build(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    expect(build_stubbed(:rain)).to be_valid
  end

  describe 'attribute' do
    it { should have_db_column :date }
    it { should have_db_column :amount }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }

    it 'formatted date' do
      rain = Rain.new date: '4/1'

      expect(rain.formatted_date).to eq "April 1, #{Time.zone.now.year}"
    end

    it 'empty date' do
      expect(Rain.new.formatted_date).to eq nil
    end
  end

  describe 'validation' do
    it { should validate_presence_of(:date).with_message(/must be a date/) }
    it { should validate_uniqueness_of(:date).scoped_to :farm_id }
    it { should validate_presence_of :amount }
    it { should validate_numericality_of :amount }
    it { should validate_presence_of :farm_id }
  end
end
