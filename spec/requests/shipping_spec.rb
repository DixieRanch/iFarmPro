require 'rails_helper'

RSpec.describe 'Shipping', type: :request do
  describe 'new page' do
    it 'displays the title of the shipment' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'h1', text:
                             'Shipping ' + location.name +
                             ' to ' + shipment.name
    end

    it 'displays lots in the location' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      lot = create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'td', text: lot.name
    end

    it 'has link to ship a lot' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_link 'Ship Lot'
    end

    it 'has submit button' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_button 'Ship'
    end
  end

  describe 'ship lot link' do
    it 'updates the shipment_id of the lot' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      lot = create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_link 'Ship Lot'

      lot.reload
      expect(lot.shipment_id).to eq shipment.id
    end

    it 'update the freezer_location_id of the lot to nil' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      lot = create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      click_link 'Ship Lot'

      lot.reload
      expect(lot.freezer_location_id).to eq nil
    end
  end
end
