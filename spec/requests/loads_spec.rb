require 'rails_helper'

RSpec.describe 'Loads', type: :request do
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
      visit loads_path

      expect(page).to have_selector 'h1', text: 'Location Overview'
    end

    it 'displays saved location names' do
      sign_in create(:user)
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      visit loads_path

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
      load1 = Load.new(location1)
      load2 = Load.new(location2)
      visit loads_path

      expect(page).to have_selector 'td', text: load1.weight
      expect(page).to have_selector 'td', text: load2.weight
    end

    context 'with nil box empty_weight' do
      it 'uses default weight' do
        sign_in create(:user)
        location = create(:freezer_location)
        box = create(:box, empty_weight: nil)
        create(:lot, full_weight: 3000, freezer_location_id: location.id,
                     box_id: box.id)
        load1 = Load.new(location)
        visit loads_path

        expect(page).to have_selector 'td', text: load1.weight
      end
    end

    it 'displays the number of lots in the location' do
      sign_in create(:user)
      location = create(:freezer_location)
      create(:lot, freezer_location_id: location.id)
      create(:lot, freezer_location_id: location.id)
      location_lot_count = Lot.where(freezer_location_id: location.id).count
      visit loads_path

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
      visit loads_path

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
      visit loads_path

      expect(page).to have_text 'Total Lot Count: ' + lot_count.to_s
    end

    it 'has move all link' do
      sign_in create(:user)
      location = create(:freezer_location)
      create(:lot, freezer_location_id: location.id)
      visit loads_path

      expect(page).to have_link 'Move All Lots'
    end

    context 'with numerical names' do
      it 'sorts in assending order' do
        set_tenant_company
        location1 = create(:freezer_location, name: '1')
        location3 = create(:freezer_location, name: '10')
        location2 = create(:freezer_location, name: '2')
        Load.new(location1)
        Load.new(location3)
        Load.new(location2)
        correct_order = [location1, location2, location3]

        expect(Load.all.map(&:location)).to eq correct_order
      end
    end

    context 'with letter names' do
      it 'sorts in assending order' do
        set_tenant_company
        location1 = create(:freezer_location, name: 'a')
        location3 = create(:freezer_location, name: 'c')
        location2 = create(:freezer_location, name: 'b')
        Load.new(location1)
        Load.new(location3)
        Load.new(location2)
        correct_order = [location1, location2, location3]

        expect(Load.all.map(&:location)).to eq correct_order
      end
    end

    context 'with alpha-numerical names' do
      it 'sorts in assending order' do
        set_tenant_company
        location1 = create(:freezer_location, name: 'a1')
        location3 = create(:freezer_location, name: 'a10')
        location2 = create(:freezer_location, name: 'a2')
        Load.new(location1)
        Load.new(location3)
        Load.new(location2)
        correct_order = [location1, location2, location3]

        expect(Load.all.map(&:location)).to eq correct_order
      end
    end
  end

  describe 'move all lots link' do
    context 'when clicked' do
      it 'redirects to the move lots form' do
        sign_in create(:user)
        create(:freezer_location)
        visit loads_path

        click_link 'Move All Lots'

        expect(page).to have_title full_title 'Move All Lots'
      end
    end
  end

  describe 'Move All Lots form' do
    it 'has new location text box' do
      sign_in create(:user)
      location = create(:freezer_location)
      location2 = create(:freezer_location)
      create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Move All Lots'

      fill_in('New Location Name', with: location2.name)
    end

    it 'has move button' do
      sign_in create(:user)
      location = create(:freezer_location)
      create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Move All Lots'

      click_button 'Move'
    end
  end
end
