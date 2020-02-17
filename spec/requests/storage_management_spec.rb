require 'rails_helper'

RSpec.describe 'StorageManagement', type: :request do
  describe 'Storage Management link' do
    context 'when clicked' do
      it 'redirects to storage management page' do
        sign_in(create(:user))

        click_link 'Storage Management'

        expect(page).to have_title full_title 'Storage Management'
      end
    end
  end

  describe 'location index' do
    it 'has correct title' do
      sign_in create(:user)
      visit storage_management_index_path

      expect(page).to have_selector 'h1', text: 'Location Overview'
    end

    it 'displays saved location names' do
      sign_in create(:user)
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      visit storage_management_index_path

      expect(page).to have_selector 'td', text: location1.name
      expect(page).to have_selector 'td', text: location2.name
    end

    it 'displays location weights' do
      sign_in create(:user)
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      create(:lot, full_weight: 3000, freezer_location_id: location1.id,
                   box_id: box1.id)
      create(:lot, full_weight: 4000, freezer_location_id: location2.id,
                   box_id: box2.id)
      visit storage_management_index_path

      expect(page).to have_selector 'td', text: location1.location_weight
      expect(page).to have_selector 'td', text: location2.location_weight
    end

    context 'with nil box empty_weight' do
      it 'uses default weight' do
        sign_in create(:user)
        location = create(:freezer_location)
        box = create(:box, empty_weight: nil)
        create(:lot, full_weight: 3000, freezer_location_id: location.id,
                     box_id: box.id)
        visit storage_management_index_path

        expect(page).to have_selector 'td', text: location.location_weight
      end
    end

    it 'displays the number of lots in the location' do
      sign_in create(:user)
      location = create(:freezer_location)
      create(:lot, freezer_location_id: location.id)
      create(:lot, freezer_location_id: location.id)
      location_lot_count = Lot.where(freezer_location_id: location.id).count
      visit storage_management_index_path

      expect(page).to have_selector 'td', text: location_lot_count
    end

    it 'displays the total storage weight' do
      sign_in create(:user)
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      create(:lot, full_weight: 3000, freezer_location_id: location1.id,
                   box_id: box1.id)
      create(:lot, full_weight: 4000, freezer_location_id: location2.id,
                   box_id: box2.id)
      storage_weight = Lot.all.map(&:net_weight).sum
      visit storage_management_index_path

      expect(page).to have_text storage_weight
    end

    it 'displays the total lot count' do
      sign_in create(:user)
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      create(:lot, freezer_location_id: location1.id)
      create(:lot, freezer_location_id: location1.id)
      create(:lot, freezer_location_id: location2.id)
      lot_count = Lot.all.count
      visit storage_management_index_path

      expect(page).to have_text 'Total Lot Count: ' + lot_count.to_s
    end

    it 'has move all link' do
      sign_in create(:user)
      location = create(:freezer_location)
      create(:lot, freezer_location_id: location.id)
      visit storage_management_index_path

      expect(page).to have_link 'Move All Lots'
    end
  end
end
