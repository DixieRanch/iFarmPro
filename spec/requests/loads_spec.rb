require 'rails_helper'

RSpec.describe 'Loads', type: :request do
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
      sign_in(user = create(:user))
      location1 = create(:freezer_location)
      location2 = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      create(:lot, full_weight: 3000, freezer_location_id: location1.id,
                   box: box1)
      create(:lot, full_weight: 4000, freezer_location_id: location2.id,
                   box: box2)
      load1 = Load.new(location1)
      load2 = Load.new(location2)
      visit loads_path
      Company.current_id = user.company.id

      expect(page).to have_selector 'td', text: load1.weight
      expect(page).to have_selector 'td', text: load2.weight
    end

    context 'with nil box empty_weight' do
      it 'uses default weight' do
        sign_in(user = create(:user))
        location = create(:freezer_location)
        box = create(:box, empty_weight: nil)
        create(:lot, full_weight: 3000, freezer_location_id: location.id,
                     box_id: box.id)
        load1 = Load.new(location)
        visit loads_path
        Company.current_id = user.company.id

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

    context 'with one lot in the location' do
      it 'displays the content type' do
        sign_in create(:user)
        content = create(:content, name: '#1s')
        location = create(:freezer_location)
        lot = create(:lot, freezer_location_id: location.id,
                           content_id: content.id)
        location_content = lot.content.name
        visit loads_path

        expect(page).to have_selector 'td', text: location_content
      end
    end

    context 'with multiple content types in the location' do
      it 'displays the content types' do
        sign_in create(:user)
        content1 = create(:content, name: '#1s')
        content2 = create(:content, name: '#2s')
        location = create(:freezer_location)
        lot = create(:lot, freezer_location_id: location.id,
                           content_id: content1.id)
        lot2 = create(:lot, freezer_location_id: location.id,
                            content_id: content2.id)
        location_content1 = lot.content.name
        location_content2 = lot2.content.name
        visit loads_path

        expect(page).to have_selector 'td', text: location_content1
        expect(page).to have_selector 'td', text: location_content2
      end

      it 'displays each content type once' do
        sign_in create(:user)
        content = create(:content)
        location = create(:freezer_location)
        lot = create(:lot, freezer_location_id: location.id,
                           content_id: content.id)
        create(:lot, freezer_location_id: location.id,
                     content_id: content.id)
        location_content1 = lot.content.name
        visit loads_path

        expect(page).to have_content(location_content1, count: 1)
      end
    end

    it 'displays total weight by content type' do
      sign_in create(:user)
      content1 = create(:content, name: '#1s')
      content2 = create(:content, name: '#2s')
      content3 = create(:content, name: '#3s')
      content4 = create(:content, name: 'Blacks')
      content5 = create(:content, name: 'Cracks')
      content6 = create(:content, name: 'Pre-Clean')
      location = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      box3 = create(:box, empty_weight: 200)
      box4 = create(:box, empty_weight: 200)
      box5 = create(:box, empty_weight: 200)
      box6 = create(:box, empty_weight: 200)
      create(:lot, full_weight: 3000, freezer_location_id: location.id,
                   box_id: box1.id, content_id: content1.id)
      create(:lot, full_weight: 4000, freezer_location_id: location.id,
                   box_id: box2.id, content_id: content2.id)
      create(:lot, full_weight: 4100, freezer_location_id: location.id,
                   box_id: box3.id, content_id: content3.id)
      create(:lot, full_weight: 4200, freezer_location_id: location.id,
                   box_id: box4.id, content_id: content4.id)
      create(:lot, full_weight: 4300, freezer_location_id: location.id,
                   box_id: box5.id, content_id: content5.id)
      create(:lot, full_weight: 4400, freezer_location_id: location.id,
                   box_id: box6.id, content_id: content6.id)
      visit loads_path

      expect(page).to have_text '#1 Weight: 2800'
      expect(page).to have_text '#2 Weight: 3800'
      expect(page).to have_text '#3 Weight: 3900'
      expect(page).to have_text 'Blacks Weight: 4000'
      expect(page).to have_text 'Cracks Weight: 4100'
      expect(page).to have_text 'Pre-Clean Weight: 4200'
    end

    context 'with shipped weight' do
      it 'updates the displayed content weight' do
        sign_in(create(:user))
        location = create(:freezer_location)
        box = create(:box)
        content = create(:content, name: 'Cracks')
        shipment = create(:shipment)
        lot = create(:lot,
                     box: box,
                     freezer_location_id: location.id,
                     content: content)
        visit loads_path
        expect(page).to have_text 'Cracks Weight: 1800'

        lot.freezer_location_id = nil
        lot.shipment_id = shipment.id
        lot.save

        visit loads_path
        expect(page).to have_text 'Cracks Weight: 0'
      end
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

      expect(page).to have_text storage_weight.to_s
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

    it 'has ship location link' do
      sign_in create(:user)
      location = create(:freezer_location)
      create(:lot, freezer_location_id: location.id)
      visit loads_path

      expect(page).to have_link 'Ship Location'
    end

    describe 'ship location link' do
      context 'when clicked' do
        it 'sends the correct location paramater' do
          sign_in create(:user)
          shipment = create(:shipment)
          location1 = create(:freezer_location)
          location2 = create(:freezer_location)
          lot1 = create(:lot, freezer_location_id: location1.id)
          lot2 = create(:lot, freezer_location_id: location2.id)
          visit loads_path

          click_link 'Ship Location', href:
                        '/shipment_selections/new?location=' + location2.id.to_s
          select(shipment.name, from: 'Shipment')
          click_button 'Select'

          expect(page).to have_text lot2.name
          expect(page).to_not have_text lot1.name
        end

        it 'sends the correct shipping paramater' do
          sign_in create(:user)
          shipment1 = create(:shipment)
          shipment2 = create(:shipment)
          create(:freezer_location)
          visit loads_path

          click_link 'Ship Location'

          select(shipment2.name, from: 'Shipment')
          click_button 'Select'

          expect(page).to have_text shipment2.name
          expect(page).to_not have_text shipment1.name
        end
      end
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
    it 'has new location select box' do
      sign_in create(:user)
      location = create(:freezer_location)
      location2 = create(:freezer_location)
      create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Move All Lots'

      select(location2.name, from: 'New Location')
    end

    it 'preselects the current location name' do
      sign_in(user = create(:user))
      create(:freezer_location, name: 'first')
      location = create(:freezer_location, name: 'second')
      lot = create(:lot, freezer_location: location)
      visit edit_load_path(location)

      click_button 'Move'
      Company.current_id = user.company.id
      lot.reload

      expect(lot.freezer_location).to eq location
    end

    it 'has move button' do
      sign_in(create(:user))
      location = create(:freezer_location)
      create(:lot, freezer_location: location)
      visit loads_path

      click_link 'Move All Lots'

      click_button 'Move'
    end

    it 'updates the load location' do
      sign_in(user = create(:user))
      location = create(:freezer_location)
      new_location = create(:freezer_location)
      lot1 = create(:lot, freezer_location: location)
      lot2 = create(:lot, freezer_location: location)
      visit loads_path

      click_link 'Move All Lots'
      select(new_location.name, from: 'New Location')
      click_button 'Move'
      Company.current_id = user.company.id
      lot1.reload
      lot2.reload

      expect(lot1.freezer_location).to eq new_location
      expect(lot2.freezer_location).to eq new_location
    end
  end

  describe 'inspect link' do
    context 'when clicked' do
      it 'renders the location inspection page' do
        sign_in(user = create(:user))
        farm = user.company.farms.first
        create(:freezer_location, name: 'location1', farm: farm)
        visit loads_path

        click_link 'Inspect'

        expect(page).to have_title full_title 'location1'
      end
    end
  end

  describe 'inspect page' do
    it 'shows all lots in the inspected location' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location = create(:freezer_location, name: 'location1', farm: farm)
      lot = create(:lot, freezer_location_id: location.id)
      visit loads_path

      click_link 'Inspect'

      expect(page).to have_selector 'td', text: lot.name
    end

    context 'with multiple locations' do
      it 'only shows lots in the selected location' do
        sign_in(user = create(:user))
        farm = user.company.farms.first
        location = create(:freezer_location, name: 'location1', farm: farm)
        lot1 = create(:lot, freezer_location_id: location.id)
        location2 = create(:freezer_location, name: 'location2', farm: farm)
        lot2 = create(:lot, freezer_location_id: location2.id)

        visit load_path(location.id)

        expect(page).to have_selector 'td', text: lot1.name
        expect(page).to_not have_selector 'td', text: lot2.name
      end
    end

    it 'shows the box name for the lots' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location = create(:freezer_location, name: 'location1', farm: farm)
      lot = create(:lot, freezer_location_id: location.id)
      visit loads_path

      click_link 'Inspect'

      expect(page).to have_selector 'td', text: lot.box.name
    end

    it 'shows the contents for the lots' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location = create(:freezer_location, name: 'location1', farm: farm)
      lot = create(:lot, freezer_location_id: location.id)
      visit load_path(location.id)

      expect(page).to have_selector 'td', text: lot.content.name
    end

    it 'shows the weights for the lots' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location = create(:freezer_location, name: 'location1', farm: farm)
      lot = create(:lot, freezer_location_id: location.id)
      visit load_path(location.id)

      expect(page).to have_selector 'td', text: lot.full_weight
    end

    it 'shows the block for the lots' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location = create(:freezer_location, name: 'location1', farm: farm)
      lot = create(:lot, freezer_location_id: location.id)
      visit load_path(location.id)

      expect(page).to have_selector 'td', text: lot.block.name
    end

    it 'shows the field for the lots' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location = create(:freezer_location, name: 'location1', farm: farm)
      lot = create(:lot, freezer_location_id: location.id)
      visit load_path(location.id)

      expect(page).to have_selector 'td', text: lot.field.name
    end
  end
end
