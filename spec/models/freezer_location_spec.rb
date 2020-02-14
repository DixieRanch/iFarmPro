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
    it 'returns the sum of net lot weights in a location' do
      set_tenant_company
      location1 = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      lot1 = create(:lot, name: 'lot1', full_weight: 2000,
                          freezer_location_id: location1.id, box_id: box1.id)
      lot2 = create(:lot, name: 'lot2', full_weight: 3000,
                          freezer_location_id: location1.id, box_id: box2.id)
      weight = (lot1.full_weight - lot1.box.empty_weight) +
               (lot2.full_weight - lot2.box.empty_weight)

      expect(location1.location_weight). to eq weight
    end

    it 'returns the weight for only one location' do
      set_tenant_company
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      seperate_box = create(:box, empty_weight: 200)

      lot1 = create(:lot, name: 'lot1', full_weight: 2000,
                          freezer_location_id: location1.id, box_id: box1.id)
      lot2 = create(:lot, name: 'lot2', full_weight: 3000,
                          freezer_location_id: location1.id, box_id: box2.id)
      create(:lot, name: 'seperate',
                   freezer_location_id: location2.id,
                   box_id: seperate_box.id)
      weight = (lot1.full_weight - lot1.box.empty_weight) +
               (lot2.full_weight - lot2.box.empty_weight)

      expect(location1.location_weight). to eq weight
    end
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

  describe 'move-all-lots-to method' do
    it 'moves all lots in a location to the new location' do
      set_tenant_company
      original_location = create(:freezer_location)
      new_location = create(:freezer_location)
      lot1 = create(:lot, freezer_location_id: original_location.id)
      lot2 = create(:lot, freezer_location_id: original_location.id)
      lot3 = create(:lot, freezer_location_id: original_location.id)

      original_location.move_all_lots_to(new_location)
      lot1.reload
      lot2.reload
      lot3.reload

      expect(lot1.freezer_location_id).to eq new_location.id
      expect(lot2.freezer_location_id).to eq new_location.id
      expect(lot3.freezer_location_id).to eq new_location.id
    end
  end
end
