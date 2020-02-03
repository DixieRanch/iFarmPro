require 'rails_helper'

describe FreezerLocation do
  valid_attributes = { name: 'A-10' }

  it 'is valid' do
    set_tenant_company

    expect(build_stubbed(:farm).freezer_locations.new(valid_attributes))
      .to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    location = create(:freezer_location)
    expect(build_stubbed(:freezer_location, farm_id: location.farm_id))
      .to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most 10 }
    it { should validate_presence_of :farm_id }
    it { should validate_presence_of :company_id }
    it 'has a unique name scoped to farm' do
      location = build_stubbed(:farm).freezer_locations.new valid_attributes

      expect(location).to validate_uniqueness_of(:name).case_insensitive
                                                       .scoped_to :farm_id
    end
  end

  describe 'associations' do
    it { should belong_to :farm }
    it { should have_many :lots }
  end

  describe 'location weight' do
    it 'returns the sum of lot weights in a location' do
      set_tenant_company
      location = create(:freezer_location)
      lot1 = create(:lot, name: 'lot1',
                          full_weight: 2000, freezer_location_id: location.id)
      lot2 = create(:lot, name: 'lot2',
                          full_weight: 3000, freezer_location_id: location.id)

      weight = lot1.full_weight + lot2.full_weight

      expect(location.location_weight). to eq weight
    end
  end
end
