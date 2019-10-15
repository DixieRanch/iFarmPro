# == Schema Information
#
# Table name: farms
#
#  id                 :integer          not null, primary key
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  company_id         :integer
#  weather_station_id :integer
#

require 'rails_helper'

describe Farm do
  valid_attributes = { name: 'Example Farm' }

  it 'is valid' do
    set_tenant_company
    weather_station = build_stubbed :weather_station

    expect(weather_station.farms.build(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    set_tenant_company

    expect(build_stubbed(:farm)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :company_id }
    it { should have_db_column :weather_station_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of :company_id }
    it { should validate_presence_of :weather_station }
    it 'has case insensitive unique name scoped to company_id' do
      set_tenant_company
      farm = create :farm

      expect(farm).to validate_uniqueness_of(:name).case_insensitive
                                                   .scoped_to :company_id
    end
  end

  describe 'associations' do
    it { should accept_nested_attributes_for :blocks }
    it { should accept_nested_attributes_for :irrigation_wells }
    it { should belong_to :weather_station }
    it { should have_many :rains }

    it 'should return blocks ordered by name' do
      set_tenant_company
      farm = create :farm
      second = farm.blocks.create name: 'Inbtween'
      third  = farm.blocks.create name: 'Last'
      first  = farm.blocks.create name: 'First'

      expect(farm.blocks.to_a).to eq [first, second, third]
    end

    it 'should return irrigation_wells ordered by name' do
      set_tenant_company
      farm = create :farm
      second = farm.irrigation_wells.create name: 'Inbetween'
      third  = farm.irrigation_wells.create name: 'Last'
      first  = farm.irrigation_wells.create name: 'First'

      expect(farm.irrigation_wells.to_a).to eq [first, second, third]
    end
  end
end
