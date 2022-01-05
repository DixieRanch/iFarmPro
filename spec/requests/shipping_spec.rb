require 'rails_helper'

RSpec.describe 'Shipping', type: :request do
  describe 'new page' do
    it 'displays the title of the shipment' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'h1', text:
                             'Shipping ' + location.name +
                             ' to ' + shipment.name
    end

    it 'displays lots in the location' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'td', text: lot.name
    end

    it 'displays the total shipped weight' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      lot = create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_button 'Ship'

      expect(page).to have_selector 'h3', text: 'weight: ' + lot.net_weight.to_s
    end

    it 'displays the box name for the lot' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'td', text: lot.box.name
    end

    it 'has ship button' do
      sign_in create(:user)
      shipment = create(:shipment)
      create(:lot)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_button 'Ship'
    end
  end

  describe 'ship button' do
    it 'updates the shipment_id of the lot' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_button 'Ship'

      lot.reload
      expect(lot.shipment_id).to eq shipment.id
    end

    it 'update the freezer_location_id of the lot to nil' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot)
      visit loads_path
      click_link 'Ship'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_button 'Ship'

      lot.reload
      expect(lot.freezer_location_id).to eq nil
    end
  end
end
