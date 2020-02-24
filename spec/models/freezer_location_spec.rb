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

  describe 'sort' do
    context 'with numerical names' do
      it 'sorts in assending order' do
        set_tenant_company
        location1 = create(:freezer_location, name: '1')
        location3 = create(:freezer_location, name: '3')
        location2 = create(:freezer_location, name: '2')
        correct_order = [location1, location2, location3]

        expect(FreezerLocation.by_name_numerically.to_a).to eq correct_order
      end
    end

    context 'with letter names' do
      it 'sorts in assending order' do
        set_tenant_company
        location1 = create(:freezer_location, name: 'a')
        location3 = create(:freezer_location, name: 'c')
        location2 = create(:freezer_location, name: 'b')
        correct_order = [location1, location2, location3]

        expect(FreezerLocation.by_name_numerically.to_a).to eq correct_order
      end
    end
    context 'with alpha-numerical names' do
      it 'sorts in assending order' do
        set_tenant_company
        location1 = create(:freezer_location, name: 'a1')
        location3 = create(:freezer_location, name: 'a10')
        location2 = create(:freezer_location, name: 'a2')
        correct_order = [location1, location2, location3]

        expect(FreezerLocation.by_name_numerically.to_a).to eq correct_order
      end
    end
  end
end
